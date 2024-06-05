//
//  SearchDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import UIKit

class SearchDIContainer {
    
    struct Dependencies {
        let userClient: FSUserClient
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeSearchFlowCoodinator(navigationController: UINavigationController) -> SearchFlowCoodinator {
        SearchFlowCoodinator(navigationController: navigationController,
                           dependencies: self)
    }
    
    func makeSearchTabBarVC(actions: SearchTabBarActions) -> SearchTabBarViewModel {
        DefaultSearchTabBarViewModel(actions: actions)
    }
    
    func makeSearchInformationVC(actions: SearchInformationStudentActions, searchType: SearchType) -> SearchInformationStudentViewModel {
        DefaultSearchInformationStudentModel(actions: actions, searchType: searchType)
    }
    
    private func makeInformationStudentVC(actions: InformationStudentActions, studentCode: String) -> InformationStudentViewModel {
        DefaultInformationStudentViewModel(actions: actions, studentCode: studentCode)
    }
    
    private func makePointTrainingVC(actions: PointTrainingActions, studentCode: String) -> PointTrainingViewModel {
        DefaultPointTrainingViewModel(actions: actions, studentCode: studentCode)
    }
}

extension SearchDIContainer: SearchFlowCoodinatorDependencies {

    func makeInformationStudentVC(actions: InformationStudentActions, studentCode: String) -> InformationStudentViewController {
        InformationStudentViewController.create(with: makeInformationStudentVC(actions: actions,studentCode: studentCode) )
    }
    
    func makeSearchTabBarVC(actions: SearchTabBarActions) -> SearchTabBarViewController {
        SearchTabBarViewController.create(with: makeSearchTabBarVC(actions: actions))
    }
    
    func makeSearchInformation(actions: SearchInformationStudentActions, searchType: SearchType) -> SearchInformationStudentViewController {
        SearchInformationStudentViewController.create(with: makeSearchInformationVC(actions: actions, searchType: searchType))
    }
    
    func makePointTrainingVC(actions: PointTrainingActions, studentCode: String, searchType: SearchType) -> PointTraingViewController {
        PointTraingViewController.create(with: makePointTrainingVC(actions: actions, studentCode: studentCode))
    }
    
}
