//
//  LoginViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import UIKit

class LoginViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    private var isShowPassword: Bool = true {
        didSet{
            passwordTxt.isSecureTextEntry = isShowPassword
            let isShowPasswordImage = isShowPassword ? R.image.eye.name : R.image.eyeSlash.name
            showPasswordBtn.setImage(UIImage(named: isShowPasswordImage), for: .normal)
        }
    }
    
    private var viewModel: LoginViewModel!
    
    class func create(with viewModel: LoginViewModel) -> LoginViewController {
        let vc = LoginViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
        
        setUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setUI() {
        loginTitle.text = R.stringLocalizable.buttonSignIn()
        emailTxt.placeholder = R.stringLocalizable.textFieldEmail()
        emailTxt.addPadding()
      
        passwordTxt.placeholder = R.stringLocalizable.textFieldPassword()
        passwordTxt.addPadding()
        
        loginBtn.setTitle(R.stringLocalizable.buttonSignIn(), for: .normal)
        
        forgotPasswordBtn.setTitle(R.stringLocalizable.buttonForgotPassword(), for: .normal)
    }
    
    private func bind(to viewModel: LoginViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            guard let self = self, let error = error else { return }

            self.show(message: error, okTitle: R.stringLocalizable.buttonOk())
        }
    }
    
    @IBAction func showPasswordAction(_ sender: Any) {
        isShowPassword = !isShowPassword
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTxt.text,
              let password = passwordTxt.text else {
            return
        }
        
        if let emailError = email.checkEmail() {
            show(message: emailError.1,
                 title: emailError.0,
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }
        
        if let passwordError = password.checkPassword() {
            show(message: passwordError.1,
                 title: passwordError.0,
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }
        
        viewModel.login(email: emailTxt.text!, password: passwordTxt.text!)
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        viewModel.forgotPassword()
    }
}
