//
//  OnboardDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation
import UIKit

class OnboardDIContainer {
    
    struct Dependencies {
        var a: String
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeOnboardFlowCoordinator(navigationController: UINavigationController) -> OnboardFlowCoodinator {
        OnboardFlowCoodinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    private func makeSplashViewModel(actions: SplashActions) -> SplashViewModel {
        DefaultSplashViewModel(actions: actions)
    }
    
    private func makeLanguageViewModel(actions: LanguageActions) -> LanguageViewModel {
        DefaultLanguageViewModel(actions: actions)
    }
}

extension OnboardDIContainer: OnboardFlowCoordinatorDependencies {
    func makeSplashVC(actions: SplashActions) -> SplashViewController {
        SplashViewController.create(with: makeSplashViewModel(actions: actions))
    }
    
    func makeLanguageVC(actions: LanguageActions) -> LanguageViewController {
        LanguageViewController.create(with: makeLanguageViewModel(actions: actions))
    }
}
