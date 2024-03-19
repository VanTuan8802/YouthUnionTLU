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
        let actions = SplashActions(showFirstLanguage: showLanguage, showIntro: show)
        let vc = dependencies.makeSplashVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showLanguage() {
        let actions = LanguageActions(showPermission: showPermission)
        let vc = dependencies.makeLanguageVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showPermission() {
        let actions = PermissionActions(showLogin: show)
        let vc = dependencies.makePermission(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func show() {
        
    }
}

