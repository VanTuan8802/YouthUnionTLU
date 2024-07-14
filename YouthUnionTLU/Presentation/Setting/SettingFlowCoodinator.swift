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
    func makeInformationStudentVC(actions: InformationStudentActions, studentCode: String) -> InformationStudentViewController
    func makeLanguageVC(actions: LanguageActions) -> LanguageViewController
    func makeChangePasswordVC(actions: ChangePasswordActions ) -> ChangePasswordViewController
}

final class SettingFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SettingFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: SettingFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func setting() {
        let actions = SettingTabBarActions(
            showInformation: {studentCode in
                self.showInformation(studentCode: studentCode)
            },
            showLanguage: showLanguage,
            showShare: show,
            showRate: show,
            showPolicy: show,
            showChangePassword: showChangePassword,
            showLogOut: showLogin,
            showHomeTabBar: showHomeTabBar,
            showSearchTabBar: showSearchTabBar)
        let vc = dependencies.makeSettingTabBarVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showInformation(studentCode: String) {
        let actions = InformationStudentActions(showSearchInformation: show,
                                                showSetting: show)
        let vc = dependencies.makeInformationStudentVC(actions: actions, studentCode: studentCode)
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
    
    private func showLanguage() {
        let actions = LanguageActions(showPermission: show, showLogin: show,
                                      showHome: showHomeTabBar)
        let vc = dependencies.makeLanguageVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showChangePassword() {
        let actions = ChangePasswordActions(showLogin: showLogin)
        let vc = dependencies.makeChangePasswordVC(actions: actions)
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
    
    private func show() {
        
    }
}
