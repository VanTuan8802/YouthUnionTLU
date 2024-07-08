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
    func makePostVC(actions: PostActions, post: PostModel) -> PostViewController
    func makeAddPostVC(actions: AddPostViewActions, postType: PostType) -> AddPostViewController
    func makeAddContentVC(actions: AddContentViewActions, post: PostMock) -> AddContentViewController
    func makeJoinActivityVC(actions: JoinActivityViewActions, post: PostModel) -> JoinActivityViewController
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
                                        showPost: { post  in
            self.showPostVc(post: post)
        },
                                        showAddPost:{ postType in
            self.showAddPost(postType: postType)
        }
        )
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
    
    private func showPostVc(post: PostModel) {
        let actions = PostActions(showSearchInformation: show,
                                  showJoinActivity: { post in
            self.showJoinActivity(post: post)
        })
        let vc = dependencies.makePostVC(actions: actions, post: post
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showJoinActivity(post: PostModel) {
        let actions = JoinActivityViewActions(showPost: backToPostVC)
        let vc = dependencies.makeJoinActivityVC(actions: actions, post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAddPost(postType: PostType) {
        let actions = AddPostViewActions(showAddContent: { post   in
            self.showAddContent(post: post, postType: postType)
        })
        let vc = dependencies.makeAddPostVC(actions: actions, postType: postType)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAddContent(post: PostMock, postType: PostType) {
        let actions = AddContentViewActions(showHome:{ listContent in
            self.backToHome(listContent: listContent)
            
        } )
        let vc = dependencies.makeAddContentVC(actions: actions, post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func backToHome(listContent: [ContentMock]) {
        let actions = HomeTabBarActions(showSearchTabBar: showSearch,
                                        showSettingTabBar: showSetting,
                                        showPost: { post in
            self.showPostVc(post: post)},
                                        showAddPost: showAddPost)
        let vc = dependencies.makeHomeTabBarVC(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func backToPostVC() {
        navigationController?.popViewController(animated: true)
    }

}
