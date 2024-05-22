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
}

extension SearchDIContainer: SearchFlowCoodinatorDependencies {
    func makeSearchTabBarVC(actions: SearchTabBarActions) -> SearchTabBarViewController {
        SearchTabBarViewController.create(with: makeSearchTabBarVC(actions: actions))
    }
    
}
