//
//  SettingTabBarViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import FirebaseAuth

struct SettingTabBarActions {
    let showHomeTabBar: () -> Void
    let showSearchTabBar: () -> Void
}

protocol SettingTabBarViewModelInput {
    func viewDidLoad()
    func openHomeTabBar()
    func openSearchTabBar()
}

protocol SettingTabBarViewModelOutput {
    var error: Observable<String?> {get}
}

protocol SettingTabBarViewModel: SettingTabBarViewModelInput, SettingTabBarViewModelOutput {
    
}

class DefaultSettingTabBarViewModel: SettingTabBarViewModel {
    var error: Observable<String?> = Observable(nil)
    
    private var actions: SettingTabBarActions

    init( actions: SettingTabBarActions) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        
    }
    
    func openHomeTabBar() {
        actions.showHomeTabBar()
    }
    
    func openSearchTabBar() {
        actions.showSearchTabBar()
    }

}


