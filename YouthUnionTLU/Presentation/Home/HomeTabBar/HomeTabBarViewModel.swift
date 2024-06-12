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
}

protocol HomeTabBarViewModelInput {
    func viewDidLoad()
    func openSearchTabBar()
    func openSettingTabBar()
    func openPost(newId: String)
}

protocol HomeTabBarViewModelOutput {
    var error: Observable<String?> {get}
    var listNew: Observable<[NewModel]?> {get}
}

protocol HomeTabBarViewModel: HomeTabBarViewModelInput, HomeTabBarViewModelOutput {
    
}

class DefaultHomeTabBarViewModel: HomeTabBarViewModel {
   
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
    
    
    private func getListNew(completion: @escaping () -> Void) {
        FSNewClient.shared.getNews(uid: uid ?? "") { listNew, error in
            guard let listNew = listNew,
                  error == nil else {
                completion()
                return
            }
            
            let sortedListNew = listNew.sorted { $0.timeCreate.dateValue() > $1.timeCreate.dateValue() }
            
            self.listNew.value = sortedListNew
            
        }
        completion()
    }
}

