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
            show(message:  R.stringLocalizable.changePasswordEnterFill(),
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        if let currentPasswordError = currentPassword.checkPassword() {
            show(message: currentPasswordError.1,
                 title: currentPasswordError.0,
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        if let newPasswordError = newPassword.checkPassword() {
            show(message: newPasswordError.1,
                 title: newPasswordError.0,
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        if let newPasswordConfirmError = newPasswordConfirm.checkPassword() {
            show(message: newPasswordConfirmError.1,
                 title: newPasswordConfirmError.0,
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        if newPassword != newPasswordConfirm {
            show(message: R.stringLocalizable.changePasswordNoMatch(),
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        let storedPasswordHash = UserDefaults.standard.string(forKey: Constants.password)
        guard let storedPasswordHash = storedPasswordHash else {
            show(message: "Error retrieving stored password.",
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        if sha256Hash(currentPassword) != storedPasswordHash {
            show(message: R.stringLocalizable.changePasswordCurrentPassword(),
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        if currentPassword == newPassword {
            show(message: R.stringLocalizable.changePasswordSame(),
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }

        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                self.show(message: error.localizedDescription,
                     title: "Error",
                     okTitle: R.stringLocalizable.buttonOk())
                return
            }
            self.viewModel.openShowLogin()
        }
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
