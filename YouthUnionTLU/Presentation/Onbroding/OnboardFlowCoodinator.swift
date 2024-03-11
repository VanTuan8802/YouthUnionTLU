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
        
    }
    
    private func show() {
        
    }
}

