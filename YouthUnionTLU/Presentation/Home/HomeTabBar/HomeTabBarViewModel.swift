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
    let showPost:(String) -> Void
    let showAddPost: () -> Void
}

protocol HomeTabBarViewModelInput {
    func viewDidLoad()
    func openSearchTabBar()
    func openSettingTabBar()
    func openPost(newId: String)
    func openAddPost()
}

protocol HomeTabBarViewModelOutput {
    var error: Observable<String?> {get}
    var listNew: Observable<[NewModel]?> {get}
    var listPostActivities: Observable<[ActivityModel]?> {get}
}

protocol HomeTabBarViewModel: HomeTabBarViewModelInput, HomeTabBarViewModelOutput {
    
}

class DefaultHomeTabBarViewModel: HomeTabBarViewModel {
    
    var listPostActivities: Observable<[ActivityModel]?> = Observable(nil)
    var listNew: Observable<[NewModel]?> = Observable(nil)
    var error: Observable<String?> = Observable(nil)
    
    private let uid = Auth.auth().currentUser?.uid
    private var actions: HomeTabBarActions
    
    init(actions: HomeTabBarActions) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        getListNew {
            
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

    func openPost(newId: String) {
        actions.showPost(newId)
    }
    
    func openAddPost() {
        actions.showAddPost()
    }
    
    private func getListNew(completion: @escaping () -> Void) {
        let path = 
        FSNewClient.shared.getNews(majorId: UserDefaultsData.shared.major) { listNew, error in
            guard let listNew = listNew,
                  error == nil else {
                completion()
                return
            }
            
            self.listNew.value = listNew.sorted { $0.timeCreate.dateValue() > $1.timeCreate.dateValue() }
            
        }
        completion()
    }
    
    private func getListPostActivity(completion: @escaping () -> Void) {
        FSNewClient.shared.getListPostActivity(major: "TLS106") { listPostActivities, error in
            guard let listPostActivities = listPostActivities,
                  error == nil else {
                completion()
                return
            }
            self.listPostActivities.value = listPostActivities
           
        }
        
        completion()
    }
}

