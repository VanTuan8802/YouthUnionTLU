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
}
