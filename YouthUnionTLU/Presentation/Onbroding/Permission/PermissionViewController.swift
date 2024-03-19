//
//  PermissionViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 14/03/2024.
//

import UIKit
import Photos
import UserNotifications

class PermissionViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var permissionTitle: UILabel!
    @IBOutlet weak var permissionContent: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var photoPermisstion: UILabel!
    @IBOutlet weak var photoSwitch: UISwitch!
    @IBOutlet weak var cameraPermission: UILabel!
    @IBOutlet weak var cameraSwitch: UISwitch!
    @IBOutlet weak var notificationPermission: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    private var viewModel: PermissionViewModel!
    
    class func create(with viewModel: PermissionViewModel) -> PermissionViewController {
        let vc = PermissionViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestPhotoLibraryPermission()
        requestCameraPermission()
        requestNotificationPermission()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        permissionTitle.text = R.stringLocalizable.permissionTitle()
        permissionContent.text = R.stringLocalizable.permissionContent()
        photoPermisstion.text = R.stringLocalizable.permissionPhotos()
        cameraPermission.text = R.stringLocalizable.permissionCamera()
        notificationPermission.text = R.stringLocalizable.permissionNotifications()
    }
    
    @IBAction func photoPermisionChangeValue(_ sender: UISwitch) {
        if sender.isOn {
            requestPhotoLibraryPermission()
        }
        
    }
    
    @IBAction func cameraPermissionChangeValue(_ sender: UISwitch) {
        if sender.isOn {
            requestCameraPermission()
        }
    }
    
    @IBAction func notificationsPermissionChangeValue(_ sender: UISwitch) {
        if sender.isOn {
            requestNotificationPermission()
        }
    }
    
    @IBAction func goAction(_ sender: Any) {
        viewModel.openLogin()
    }
}

extension PermissionViewController {
    func requestPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        DispatchQueue.main.async {
            switch status {
            case .authorized, .limited:
                self.photoSwitch.isOn = true
            case .denied, .restricted:
                self.photoSwitch.isOn = false
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    DispatchQueue.main.async {
                        self.requestPhotoLibraryPermission()
                    }
                }
            @unknown default:
                break
            }
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.cameraSwitch.isOn = true

                } else {
                    self.cameraSwitch.isOn = false
                }
            }
        }
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: options) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.notificationSwitch.isOn = true
                    print("Notification permission granted.")
                } else {
                    self.notificationSwitch.isOn = false
                    if let error = error {
                        print("Notification permission denied: \(error.localizedDescription)")
                    } else {
                        print("Notification permission denied: Unknown error.")
                    }
                }
            }
        }
    }
}
