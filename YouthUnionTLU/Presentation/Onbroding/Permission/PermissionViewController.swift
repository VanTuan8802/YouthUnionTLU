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
        goBtn.setTitle(R.stringLocalizable.buttonGo(), for: .normal)
        
        photoSwitch.isOn = PermissionManager.shared.checkPhotoLibraryPermission()
        cameraSwitch.isOn = PermissionManager.shared.checkCameraPermission()
        notificationSwitch.isOn = PermissionManager.shared.checkNotificationPermission()
    }
    
    @IBAction func photoPermisionChangeValue(_ sender: UISwitch) {
        if sender.isOn {
            PermissionManager.shared.requestPhotoLibraryPermission { result in
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = result
                }
            }
        }
    }
    
    @IBAction func cameraPermissionChangeValue(_ sender: UISwitch) {
        if sender.isOn {
            PermissionManager.shared.requestCameraPermission { result in
                DispatchQueue.main.async {
                    self.cameraSwitch.isOn = result
                }
            }
        }
    }
    
    @IBAction func notificationsPermissionChangeValue(_ sender: UISwitch) {
        if sender.isOn {
            PermissionManager.shared.requestNotificationPermission { result in
                DispatchQueue.main.async {
                    self.notificationSwitch.isOn = result
                }
            }
        }
    }
    
    @IBAction func goAction(_ sender: Any) {
        viewModel.openLogin()
    }
}
