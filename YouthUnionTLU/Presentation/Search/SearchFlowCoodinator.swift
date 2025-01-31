//
//  SearchFlowCoodinator.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 22/5/24.
//

import Foundation
import UIKit

protocol SearchFlowCoodinatorDependencies {
    func makeSearchTabBarVC(actions: SearchTabBarActions) -> SearchTabBarViewController
    
    func makeSearchInformation(actions: SearchInformationStudentActions, searchType: SearchType) -> SearchInformationStudentViewController
    
    func makeInformationStudentVC(actions: InformationStudentActions, studentCode: String) -> InformationStudentViewController
    
    func makePointTrainingVC(actions: PointTrainingActions, studentCode: String, searchType: SearchType) -> PointTraingViewController
    
    func makeSearchJoinActivity(action: SearchJoinActivityActions, studentCode: String, searchType: SearchType) -> SearchJoinActivityViewController
}

final class SearchFlowCoodinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SearchFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController? = nil, dependencies: SearchFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func search() {
        let actions = SearchTabBarActions(showHomeTabBar: showHome,
                                          showSettingTabBar: showSetting,
                                          showSearchInformation: { searchType in
            self.showSearchInformation(searchType: searchType)
            
        }, showMyScore: {
            self.showPointTraining(studentCode: UserDefaultsData.shared.studentCode)
        }, showMyJoinActivity: {
            self.showJoinActivity(studentCode: UserDefaultsData.shared.studentCode)
        } )
        let vc = dependencies.makeSearchTabBarVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func show() {
        
    }
    
    private func showHome() {
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
    
    private func showSetting() {
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
    
    private func showSearchActivity() {
        
    }
    
    private func showSearchScore() {
        
    }
    
    private func showSearchInformation(searchType: SearchType) {
        let actions = SearchInformationStudentActions(
            showInformationStudent: { studentCode in
                self.showInformation(studentCode: studentCode)
            },
            showjoinActivity: { studentCode in
                self.showJoinActivity(studentCode: studentCode)
            }
            ,
            showPointTraining: {studentCode in
                self.showPointTraining(studentCode: studentCode)
            },
            showSearch: {
                self.showPointTraining(studentCode: UserDefaultsData.shared.studentCode)
            }
        )
        
        let vc = dependencies.makeSearchInformation(actions: actions, searchType: searchType)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func showInformation(studentCode: String) {
        let actions = InformationStudentActions(
            showSearchInformation: show,
            showSetting: show
        )
        let vc = dependencies.makeInformationStudentVC(actions: actions, studentCode: studentCode)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPointTraining(studentCode: String) {
        let actions = PointTrainingActions(showSearchInformation: show)
        let vc = dependencies.makePointTrainingVC(actions: actions, studentCode: studentCode, searchType: .searchPointTraining)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showJoinActivity(studentCode: String) {
        let actions = SearchJoinActivityActions(showSearchInformation: show)
        let vc = dependencies.makeSearchJoinActivity(action: actions, studentCode: studentCode, searchType: .searchPointTraining)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func popSearchTabBar() {
        navigationController?.popViewController(animated: true)
    }
}
