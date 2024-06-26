//
//  HomeTabBarActions.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import FirebaseAuth

struct HomeTabBarActions {
    let showSearchTabBar: () -> Void
    let showSettingTabBar: () -> Void
    let showPost:(String,PostType) -> Void
    let showAddPost: (PostType) -> Void
}

protocol HomeTabBarViewModelInput {
    func viewDidLoad()
    func openSearchTabBar()
    func openSettingTabBar()
    func openPost(newId: String, postType: PostType)
    func openAddPost(postType: PostType)
}

protocol HomeTabBarViewModelOutput {
    var error: Observable<String?> {get}
    var listPostNews: Observable<[PostModel]?> {get}
    var listPostActivities: Observable<[PostModel]?> {get}
}

protocol HomeTabBarViewModel: HomeTabBarViewModelInput, HomeTabBarViewModelOutput {
    
}

class DefaultHomeTabBarViewModel: HomeTabBarViewModel {
    
    var listPostActivities: Observable<[PostModel]?> = Observable(nil)
    var listPostNews: Observable<[PostModel]?> = Observable(nil)
    var error: Observable<String?> = Observable(nil)
    
    private let uid = Auth.auth().currentUser?.uid
    private var actions: HomeTabBarActions
    
    init(actions: HomeTabBarActions) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        getListPostNew() {
            
        }
        
        getListPostActivity {
            
        }
    }
    
    func openSearchTabBar() {
        actions.showSearchTabBar()
    }
    
    func openSettingTabBar() {
        actions.showSettingTabBar()
    }

    func openPost(newId: String, postType: PostType) {
        actions.showPost(newId, postType)
    }
    
    func openAddPost(postType: PostType) {
        actions.showAddPost(postType)
    }
    
    private func getListPostNew(completion: @escaping () -> Void) {
        FSPostClient.shared.getPosts(majorId: UserDefaultsData.shared.major,
                                     postType: .new) { listNew, error in
            guard let listNew = listNew,
                  error == nil else {
                completion()
                return
            }
            
            self.listPostNews.value = listNew.sorted { $0.timeCreate.dateValue() > $1.timeCreate.dateValue() }
            
        }
        completion()
    }
    
    private func getListPostActivity(completion: @escaping () -> Void) {
        FSPostClient.shared.getPosts(majorId: UserDefaultsData.shared.major,
                                     postType: .activity) { listActivity, error in
            guard let listActivity = listActivity,
                  error == nil else {
                completion()
                return
            }
            
            self.listPostActivities.value = listActivity.sorted { $0.timeCreate.dateValue() > $1.timeCreate.dateValue() }
            
        }
        completion()
    }
}

