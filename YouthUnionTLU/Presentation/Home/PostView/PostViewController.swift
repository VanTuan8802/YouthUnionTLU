//
//  PostViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import UIKit
import AVFoundation

class PostViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var contentsTableView: UITableView!
    
    private var listContent: [ContentModel] = []
    private var viewModel: PostViewModel!
    var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setUpTableView()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    class func create(with viewModel: PostViewModel) -> PostViewController {
        let vc = PostViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func setUpTableView() {
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        
        contentsTableView.rowHeight = UITableView.automaticDimension
        contentsTableView.register(UINib(nibName: ContentTableViewCell.className, bundle: nil), forCellReuseIdentifier: ContentTableViewCell.className)
    }
    
    private func bind(to viewModel: PostViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error, okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
        
        viewModel.listContent.observe(on: self) { listContent in
            guard let listContent = listContent else {
                return
            }
            
            self.listContent = listContent
            self.contentsTableView.reloadData()
        }
    }
    
    private func setUI() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        let frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 200)
        previewLayer.frame = frame
        
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissScanner))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        captureSession.startRunning()
    }
    
    @objc private func dismissScanner() {
        captureSession.stopRunning()
        previewLayer.removeFromSuperlayer()
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported",
                                   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanQR(_ sender: Any) {
        setUI()
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.className, for: indexPath) as! ContentTableViewCell
        cell.fetchData(content: listContent[indexPath.row])
        return cell
    }
}

extension PostViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
