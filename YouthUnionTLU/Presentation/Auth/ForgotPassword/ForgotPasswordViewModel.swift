//
//  ForgotPasswordActions.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import FirebaseAuth

struct ForgotPasswordActions {
    let showLogin: () -> Void
}

protocol ForgotPasswordViewModelInput {
    func viewDidLoad()
    func changePassword(email: String)
    func backLogin()
}

protocol ForgotPasswordViewModelOutPut {
    var error: Observable<String?> {get}
}

protocol ForgotPasswordViewModel: ForgotPasswordViewModelInput, ForgotPasswordViewModelOutPut {
    
}

class DefaultForgotPasswordViewModel: ForgotPasswordViewModel {
    var error: Observable<String?> = Observable(nil)
    
    private let actions: ForgotPasswordActions
    
    init(actions: ForgotPasswordActions) {
        self.actions = actions
    }
}

extension DefaultForgotPasswordViewModel {
    func viewDidLoad() {
        
    }
    
    func changePassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.error.value = error.localizedDescription
            } else {
                self?.actions.showLogin()
            }
        }
    }
    
    func backLogin() {
        actions.showLogin()
    }
}
