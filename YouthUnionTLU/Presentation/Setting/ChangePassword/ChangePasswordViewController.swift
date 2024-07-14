//
//  ChangePasswordViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 9/7/24.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var changePasswordTitle: UILabel!
    @IBOutlet weak var currentPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordConfirmTxt: UITextField!
    @IBOutlet weak var showCurrentPassword: UIButton!
    @IBOutlet weak var showNewPassword: UIButton!
    @IBOutlet weak var showConfirmPassword: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    
    private var isShowCurrentPassword: Bool = true {
        didSet{
            currentPasswordTxt.isSecureTextEntry = isShowCurrentPassword
            let isShowCurrenntPasswordImage = isShowCurrentPassword ? R.image.eye.name : R.image.eyeSlash.name
            showCurrentPassword.setImage(UIImage(named: isShowCurrenntPasswordImage), for: .normal)
        }
    }
    
    private var isShowNewPassword: Bool = true {
        didSet{
            newPasswordTxt.isSecureTextEntry = isShowNewPassword
            let isShowPasswordImage = isShowNewPassword ? R.image.eye.name : R.image.eyeSlash.name
            showNewPassword.setImage(UIImage(named: isShowPasswordImage), for: .normal)
        }
    }
    
    private var isShowConfirmPassword: Bool = true {
        didSet{
            newPasswordConfirmTxt.isSecureTextEntry = isShowConfirmPassword
            let isShowPasswordImage = isShowConfirmPassword ? R.image.eye.name : R.image.eyeSlash.name
            showConfirmPassword.setImage(UIImage(named: isShowPasswordImage), for: .normal)
        }
    }
    
    private var viewModel : ChangePasswordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    class func create(with viewModel: ChangePasswordViewModel) -> ChangePasswordViewController {
        let vc = ChangePasswordViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func setUI() {
        currentPasswordTxt.addPadding()
        newPasswordTxt.addPadding()
        newPasswordConfirmTxt.addPadding()
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        guard let currentPassword = currentPasswordTxt.text,
              let newPassword = newPasswordTxt.text,
              let newPasswordConfirm = newPasswordConfirmTxt.text else {
            return
        }
        
        if (sha256Hash(currentPassword) == UserDefaults.standard.string(forKey: Constants.password) &&
            currentPassword != newPassword &&
            newPassword == newPasswordConfirm
        ) {
            Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                guard error != nil else {
                    return
                }
                
                self.viewModel.openShowLogin()
            }
        }
        viewModel.openShowLogin()
    }
    
    @IBAction func showCurrentPasswordAction(_ sender: Any) {
        isShowCurrentPassword = !isShowCurrentPassword
    }
    
    @IBAction func showNewPasswordAction(_ sender: Any) {
        isShowNewPassword = !isShowNewPassword
    }
    
    @IBAction func showConfirmPasswordAction(_ sender: Any) {
        isShowConfirmPassword = !isShowConfirmPassword
    }
}
