//
//  HomeDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import UIKit

class HomeDIContainer {
    
    struct Dependencies {
        let userClient: FSUserClient
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeFlowCoodinator(navigationController: UINavigationController) -> HomeFlowCoodinator {
        HomeFlowCoodinator(navigationController: navigationController,
                           dependencies: self)
    }
    
    func makeHomeTabBarvc(actions: HomeTabBarActions) -> HomeTabBarViewModel {
        DefaultHomeTabBarViewModel(actions: actions)
    }
    
    func makePostvc(actions: PostActions, newId: String, postType: PostType) -> PostViewModel {
        DefaultPostViewModel(actions: actions,
                             newId: newId,
                             postType: postType)
    }
    
    func makeAddPostVC(actions: AddPostViewActions,postType: PostType) -> AddPostViewModel {
        DefaultAddPostViewModel(actions: actions, postType: postType)
    }
    
    func makeAddContentVC(actions: AddContentViewActions, post: PostMock) -> AddContentViewModel {
        DefaultAddContentViewModel(actions: actions,
                                   post: post)
    }
}

extension HomeDIContainer: HomeFlowCoodinatorDependencies {
    
    func makeHomeTabBarVC(actions: HomeTabBarActions) -> HomeTabBarViewController {
        HomeTabBarViewController.create(with: makeHomeTabBarvc(actions: actions))
    }
    
    func makePostVC( actions: PostActions, newId: String, postType: PostType) -> PostViewController {
        PostViewController.create(with: makePostvc(actions: actions, 
                                                   newId: newId,
                                                   postType: postType))
    }
    
    func makeAddPostVC(actions: AddPostViewActions, postType: PostType) -> AddPostViewController {
        AddPostViewController.create(with: makeAddPostVC(actions: actions, postType: postType))
    }
    
    func makeAddContentVC(actions: AddContentViewActions, post: PostMock) -> AddContentViewController {
        AddContentViewController.create(with: makeAddContentVC(actions: actions,post: post))
    }
}
