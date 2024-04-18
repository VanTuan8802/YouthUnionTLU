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
}

protocol HomeTabBarViewModelInput {
    func viewDidLoad()
    func openSearchTabBar()
    func openSettingTabBar()
}

protocol HomeTabBarViewModelOutput {
    var error: Observable<String?> {get}
}

protocol HomeTabBarViewModel: HomeTabBarViewModelInput, HomeTabBarViewModelOutput {
    
}

class DefaultHomeTabBarViewModel: HomeTabBarViewModel {
    var error: Observable<String?> = Observable(nil)
    
    private var actions: HomeTabBarActions
    
    init(actions: HomeTabBarActions) {
        self.actions = actions
    }
    
    func viewDidLoad() {
    }
    
    func openSearchTabBar() {
        actions.showSearchTabBar()
    }
    
    func openSettingTabBar() {
        actions.showSettingTabBar()
    }

}

