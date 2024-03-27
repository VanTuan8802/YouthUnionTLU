//
//  SettingFlowCoodinator.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import UIKit

protocol SettingFlowCoodinatorDependencies {
    func makeSettingTabBarVC(actions: SettingTabBarActions) -> SettingTabBarViewController
}

final class SettingFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SettingFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: SettingFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func setting() {
        let actions = SettingTabBarActions(showHomeTabBar: showHomeTabBar,
                                           showSearchTabBar: showSearchTabBar)
        let vc = dependencies.makeSettingTabBarVC(actions: actions)
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
    
    func showSearchTabBar() {
        guard let navigationController = navigationController else {
            return
        }
        
        let appDIContainer = AppDIContainer()
        let appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )

        appFlowCoordinator.search()
    }
}
