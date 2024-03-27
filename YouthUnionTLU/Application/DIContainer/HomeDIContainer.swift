//
//  HomeDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import UIKit

class HomeDIContainer {
    
    struct Dependencies {
        let userClient: FSUserClient
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeFlowCoodinator(navigationController: UINavigationController) -> HomeFlowCoodinator {
        HomeFlowCoodinator(navigationController: navigationController,
                           dependencies: self)
    }
    
    func makeHomeTabBarvc(actions: HomeTabBarActions) -> HomeTabBarViewModel {
        DefaultHomeTabBarViewModel(actions: actions)
    }
}

extension HomeDIContainer: HomeFlowCoodinatorDependencies {
    func makeHomeTabBarVC(actions: HomeTabBarActions) -> HomeTabBarViewController {
        HomeTabBarViewController.create(with: makeHomeTabBarvc(actions: actions))
    }
    
}
