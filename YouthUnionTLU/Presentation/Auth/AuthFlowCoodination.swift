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
                                   showForgotPassword: showHome)
        let vc = dependencies.makeLoginVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    func showHome() {
        
    }
}
