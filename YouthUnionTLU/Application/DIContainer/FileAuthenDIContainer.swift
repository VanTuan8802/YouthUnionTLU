//
//  FileAuthenDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import UIKit

class AuthenDIContainer {
    
    struct Dependencies {
        let authClient: FSFireAuthClient
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeAuthenFlowCoodinator(navigationController: UINavigationController) -> AuthenFlowCoodinator {
        AuthenFlowCoodinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    private func makeLoginViewModel(actions: LoginActions) ->LoginViewModel{
        DefaultLoginViewModel(actions: actions, authClient: dependencies.authClient)
    }
    
    private func makeJoinForgotPasswordVC(actions: ForgotPasswordActions) -> ForgotPasswordViewModel {
        DefaultForgotPasswordViewModel(actions: actions)
    }
}

extension AuthenDIContainer: AuthenFlowCoodinatorDependencies {
    func makeLoginVC(actions: LoginActions) -> LoginViewController {
        return LoginViewController.create(with: makeLoginViewModel(actions: actions))
    }
    
    func makeForgotPasswordVC(actions: ForgotPasswordActions) -> ForgotPasswordViewController {
        ForgotPasswordViewController.create(with: makeJoinForgotPasswordVC(actions: actions))
    }
}


