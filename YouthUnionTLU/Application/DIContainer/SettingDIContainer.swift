//  SettingDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import UIKit

class SettingDIContainer {
    
    struct Dependencies {
        let userClient: FSUserClient
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeSettingFlowCoodinator(navigationController: UINavigationController) -> SettingFlowCoodinator {
        SettingFlowCoodinator(navigationController: navigationController,
                           dependencies: self)
    }
    
    func makeSettingTabBarVC(actions: SettingTabBarActions) -> SettingTabBarViewModel {
        DefaultSettingTabBarViewModel(actions: actions)
    }
    
    private func makeInformationStudentVC(actions: InformationStudentActions, studentCode: String) -> InformationStudentViewModel {
        DefaultInformationStudentViewModel(actions: actions, studentCode: studentCode)
    }
    
    private func makeLanguageVC(actions: LanguageActions) -> LanguageViewModel {
        DefaultLanguageViewModel(actions: actions)
    }
    
    private func makeChangePassword(actions: ChangePasswordActions) -> ChangePasswordViewModel {
        DefaultChangePasswordViewModel( actions: actions)
    }
}

extension SettingDIContainer: SettingFlowCoodinatorDependencies {
    
    func makeSettingTabBarVC(actions: SettingTabBarActions) -> SettingTabBarViewController {
        SettingTabBarViewController.create(with: makeSettingTabBarVC(actions: actions))
    }
    
    func makeInformationStudentVC(actions: InformationStudentActions, studentCode: String) -> InformationStudentViewController {
        InformationStudentViewController.create(with: makeInformationStudentVC(actions: actions, studentCode: studentCode))
    }
    
    func makeLanguageVC(actions: LanguageActions) -> LanguageViewController {
        LanguageViewController.create(with: makeLanguageVC(actions: actions))
    }
    
    func makeChangePasswordVC(actions: ChangePasswordActions) -> ChangePasswordViewController {
        ChangePasswordViewController.create(with: makeChangePassword(actions: actions))
    }

}

