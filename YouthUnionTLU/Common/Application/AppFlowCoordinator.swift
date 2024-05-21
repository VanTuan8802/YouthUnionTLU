//
//  AppFlowCoordinator.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation
import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let onboardDIContainer = appDIContainer.makeOnboardDIContainer()
        let flow = onboardDIContainer.makeOnboardFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    func auth() {
        let authenDIContainer = appDIContainer.makeAuthenDIContainer()
        let flow = authenDIContainer.makeAuthenFlowCoodinator(navigationController: navigationController)
        flow.login()
    }
    
    func home() {
        let homeDIContainer = appDIContainer.makeHomeDIContainer()
        let flow = homeDIContainer.makeHomeFlowCoodinator(navigationController: navigationController)
        flow.home()
    }
    
    func search() {
        let searchDIContainer = appDIContainer.makeSearchDIContainer()
        let flow = searchDIContainer.makeSearchFlowCoodinator(navigationController: navigationController)
        flow.search()
    }
    
    func setting() {
        let settingDIContainer = appDIContainer.makeSettingDIContainer()
        let flow = settingDIContainer.makeSettingFlowCoodinator(navigationController: navigationController)
        flow.setting()
    }
}
