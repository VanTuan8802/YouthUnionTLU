//
//  LoginActions.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import FirebaseAuth

struct LoginActions {
    let showHome: () -> Void
    let showForgotPassword: () ->Void
}

protocol LoginViewModelInput {
    func viewDidLoad()
    func login(email: String, password: String)
    func forgotPassword()
}

protocol LoginViewModelOutput {
    var error: Observable<String?> {get}
}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput { }

class DefaultLoginViewModel: LoginViewModel {
    var error: Observable<String?> = Observable(nil)
    
    private let actions: LoginActions
    private var uid = Auth.auth().currentUser?.uid
    private var authClient: AuthClient
    
    init(actions: LoginActions, authClient: AuthClient) {
        self.actions = actions
        self.authClient = authClient
    }
}

extension DefaultLoginViewModel {
    func viewDidLoad() {
        
    }
    
    func login(email: String, password: String) {
        LoadingView.show()
        FSFireAuthClient.shared.login(email: email, password: password) { [weak self] error in
            guard let self = self, error == nil else {
                self?.error.value = R.stringLocalizable.errorLoginMessage()
                LoadingView.hide()
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                LoadingView.hide()
                return
            }
            
            FSUserClient.shared.getPossionUser(uid: uid) { positionStudent, error in
                guard error == nil else {
                    LoadingView.hide()
                    return
                }
                
                guard let positionStudent = positionStudent else {
                    LoadingView.hide()
                    return
                }
                
                UserDefaultsData.shared.posision = positionStudent.position
                
                if positionStudent.position == Position.member.rawValue {
                    UserDefaultsData.shared.studentCode = positionStudent.student_Code ?? ""
                }
                
                UserDefaultsData.shared.major = positionStudent.majorId ?? ""

                LoadingView.hide()
                UserDefaultsData.shared.showLogin = true
                self.actions.showHome()
            }
        }
    }

    
    func forgotPassword() {
        actions.showForgotPassword()
    }
}
