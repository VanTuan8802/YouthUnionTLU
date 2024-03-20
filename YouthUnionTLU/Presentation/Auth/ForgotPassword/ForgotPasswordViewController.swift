//
//  ForgotPasswordViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import UIKit

class ForgotPasswordViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var forgotPasswordTitle: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    @IBOutlet weak var backToLoginBtn: UIButton!
    
    private var viewModel: ForgotPasswordViewModel!
    
    class func create(with viewModel: ForgotPasswordViewModel) -> ForgotPasswordViewController {
        let vc = ForgotPasswordViewController.instantiateViewController()
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
    
    private func bind(to viewModel: ForgotPasswordViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            guard let self = self, let error = error else { return }
            
            self.show(message: error, okTitle: R.stringLocalizable.buttonOk())
        }
    }
    
    private func setUI() {
        forgotPasswordTitle.text = R.stringLocalizable.buttonForgotPassword()
        
        emailTxt.placeholder = R.stringLocalizable.textFieldEmail()
        emailTxt.addPadding()
        
        resetPasswordBtn.setTitle(R.stringLocalizable.buttonResetPassword(), for: .normal)
        
        backToLoginBtn.setTitle(R.stringLocalizable.buttonBackLogin(), for: .normal)
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        guard let email = emailTxt.text else {
            return
        }
        
        if let emailError = email.checkEmail() {
            show(message: emailError.1,
                 title: emailError.0,
                 okTitle: R.stringLocalizable.buttonOk())
            return
        }
        
        show(message: R.stringLocalizable.lableSendEmail(),
             title: R.stringLocalizable.buttonResetPassword(),
             okTitle: R.stringLocalizable.buttonOk(),
             okAction: {_ in
            if let gmailURL = URL(string: "googlegmail://") {
                if UIApplication.shared.canOpenURL(gmailURL) {
                    UIApplication.shared.open(gmailURL, options: [:], completionHandler: nil)
                } else {
                    if let gmailWebURL = URL(string: "https://mail.google.com/") {
                        UIApplication.shared.open(gmailWebURL, options: [:], completionHandler: nil)
                    }
                }
            }
        })
        
        viewModel.changePassword(email: email)
    }
    
    @IBAction func backToLoginAction(_ sender: Any) {
        viewModel.backLogin()
    }
}
