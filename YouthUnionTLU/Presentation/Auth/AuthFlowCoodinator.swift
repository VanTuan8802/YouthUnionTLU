//
//  AuthFlowCoodination.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import UIKit

protocol AuthenFlowCoodinatorDependencies {
    func makeLoginVC(actions: LoginActions) -> LoginViewController
    func makeForgotPasswordVC(actions: ForgotPasswordActions) -> ForgotPasswordViewController
}

final class AuthenFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthenFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: AuthenFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func login() {
        let actions = LoginActions(showHome: showHome,
                                   showForgotPassword: showForgotPassword)
        let vc = dependencies.makeLoginVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showForgotPassword() {
        let actions = ForgotPasswordActions(showLogin: popShowLogin)
        let vc = dependencies.makeForgotPasswordVC(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func popShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func showHome() {
        guard let navigationController = navigationController else {
            return
        }
        
        let appDIContainer = AppDIContainer()
        let appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )

        appFlowCoordinator.home()
    }
}
