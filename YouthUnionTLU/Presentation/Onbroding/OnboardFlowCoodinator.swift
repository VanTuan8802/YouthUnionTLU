//
//  OnboardFlowCoodinator.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation
import UIKit

protocol OnboardFlowCoordinatorDependencies {
    func makeSplashVC(actions: SplashActions) -> SplashViewController
    func makeLanguageVC(actions: LanguageActions) -> LanguageViewController
    func makePermission(actions: PermissionActions) -> PermissionViewController
}

final class OnboardFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: OnboardFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: OnboardFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = SplashActions(showFirstLanguage: showLanguage,
                                    showPermission: showPermission,
                                    showLogin: showLogin,
                                    showHome: showHome)
        let vc = dependencies.makeSplashVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showLanguage() {
        let actions = LanguageActions(showPermission: showPermission, showLogin: showLogin,
                                      showHome: showHome)
        let vc = dependencies.makeLanguageVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showPermission() {
        let actions = PermissionActions(showLogin: showLogin)
        let vc = dependencies.makePermission(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showLogin() {
        guard let navigationController = navigationController else {
            return
        }
        
        let appDIContainer = AppDIContainer()
        let appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        
        appFlowCoordinator.auth()
    }
    
    private func showHome() {
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

