//
//  SearchFlowCoodinator.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import UIKit

protocol SearchFlowCoodinatorDependencies {
    func makeSearchTabBarVC(actions: SearchTabBarActions) -> SearchTabBarViewController
}

final class SearchFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SearchFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: SearchFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func search() {
        let actions = SearchTabBarActions(showHomeTabBar: showHomeTabBar,
                                          showSettingTabBar: show)
        let vc = dependencies.makeSearchTabBarVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func show() {
        
    }
    
    func showHomeTabBar() {
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
    
    func showSetting() {
        guard let navigationController = navigationController else {
            return
        }
        
        let appDIContainer = AppDIContainer()
        let appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )

        appFlowCoordinator.setting()
    }
}
