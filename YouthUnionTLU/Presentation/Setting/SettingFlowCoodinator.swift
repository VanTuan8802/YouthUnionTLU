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
    func makeInformationStudentVC(actions: InformationStudentActions) -> InformationStudentViewController
}

final class SettingFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SettingFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: SettingFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func setting() {
        let actions = SettingTabBarActions(showInformation: showInformation,
                                           showLanguage: show,
                                           showShare: show,
                                           showRate: show,
                                           showPolicy: show,
                                           showChangePassword: show,
                                           showLogOut: show,
                                           showHomeTabBar: showHomeTabBar,
                                           showSearchTabBar: showSearchTabBar)
        let vc = dependencies.makeSettingTabBarVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func show() {
        
    }
    
    private func showInformation() {
        let actions = InformationStudentActions(showSearchInformation: show,
                                                showSetting: show)
        let vc = dependencies.makeInformationStudentVC(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showHomeTabBar() {
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
    
    private func showSearchTabBar() {
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
