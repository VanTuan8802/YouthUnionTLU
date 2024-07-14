//
//  AddPostViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 12/6/24.
//

import UIKit
import Photos
import FirebaseFirestoreInternal

class AddPostViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var activityInputView: UIStackView!
    @IBOutlet weak var timeStartLb: UILabel!
    @IBOutlet weak var timeStart: UIDatePicker!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var timeCheckInLb: UILabel!
    @IBOutlet weak var timeCheckIn: UIDatePicker!
    @IBOutlet weak var qrText: UITextField!
    @IBOutlet weak var addImageLb: UILabel!
    @IBOutlet weak var viewImportPhoto: UIView!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var contitnueBtn: UIButton!
    
    private var viewModel: AddPostViewModel!
    private var postType: PostType = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidload()
        setUI()
        
        titleTextView.delegate = self
        
        setupPlaceholder()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    private func setUI() {
        
        titleLb.text = R.stringLocalizable.addPostHeading()
        timeStartLb.text = R.stringLocalizable.addPostTimeStart()
        timeCheckInLb.text = R.stringLocalizable.addPostTimeCheckIn()
        address.placeholder = R.stringLocalizable.addPostAddress()
        address.addPadding()
        qrText.addPadding()
        qrText.placeholder = R.stringLocalizable.addPostQrCode()
        addImageLb.text = R.stringLocalizable.addPostImage()
        contitnueBtn.setTitle(R.stringLocalizable.buttonContinue(), for: .normal)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupPlaceholder() {
        if titleTextView.text.isEmpty {
            titleTextView.text = R.stringLocalizable.addPostTitle()
            titleTextView.textColor = .lightGray
        }
    }
    
    class func create(with viewModel: AddPostViewModel) -> AddPostViewController {
        let vc = AddPostViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func bind(to viewModel: AddPostViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error,
                           okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
        
        viewModel.postTypeValue.observe(on: self) { [weak self] postTypeValue in
            guard let postTypeValue = postTypeValue else {
                return
            }
            self?.postType = postTypeValue
            if self?.postType == .new {
                self?.activityInputView.isHidden = true
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        if PermissionManager.shared.checkPhotoLibraryPermission() == false {
            PermissionManager.shared.requestPhotoLibraryPermission { result in
                DispatchQueue.main.async {
                    if result == false {
                        let alertController = UIAlertController(title: "",
                                                                message: "Mở cài đặt và cấp quyền ảnh để tiếp tục",
                                                                preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            PermissionManager.shared.openSettingPermission()
                        }
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.presentImagePicker()
                    }
                }
            }
        } else {
            presentImagePicker()
        }
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard let title = titleTextView.text,
              title != R.stringLocalizable.addPostTitle() ,
              let address = address.text,
              let qrText = qrText.text,
              let image = imagePost.image else {
            return
        }
        
        var postModel: PostMock
        
        if postType == .activity {
            postModel = PostMock(id: UUID().uuidString,
                                 imageNew: image,
                                 title: title,
                                 timeCreate: Timestamp(date: Date()),
                                 address: address,
                                 timeStart: Timestamp(date: timeStart.date),
                                 timeCheckIn: Timestamp(date: timeCheckIn.date),
                                 qrText: qrText,
                                 postType: .activity)
        } else {
            postModel = PostMock(id: UUID().uuidString,
                                 imageNew: image,
                                 title: title,
                                 timeCreate: Timestamp(date: Date()),
                                 postType: postType)
        }

        self.viewModel.openAddContent(post: postModel)
        
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewImportPhoto.isHidden = true
            imagePost.isHidden = false
            imagePost.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == R.stringLocalizable.addPostTitle() {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = R.stringLocalizable.addPostTitle()
            textView.textColor = .lightGray
        }
    }
}
