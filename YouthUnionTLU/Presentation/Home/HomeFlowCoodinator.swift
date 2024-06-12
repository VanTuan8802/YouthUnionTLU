//
//  HomeFlowCoodinator.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import UIKit

protocol HomeFlowCoodinatorDependencies {
    func makeHomeTabBarVC(actions: HomeTabBarActions) -> HomeTabBarViewController
    func makePostVC(actions: PostActions, newId: String) -> PostViewController
}

final class HomeFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: HomeFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: HomeFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func home() {
        let actions = HomeTabBarActions(showSearchTabBar: showSearch,
                                        showSettingTabBar: showSetting, 
                                        showPost: { newId in
            self.showPostVc(newId: newId)
        })
        let vc = dependencies.makeHomeTabBarVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func show() {
        
    }
    
    func showSearch() {
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
    
    private func showPostVc(newId: String) {
        let actions = PostActions(showSearchInformation: show)
        let vc = dependencies.makePostVC(actions: actions, newId: newId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
