//
//  SettingTabBarViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import FirebaseAuth

struct SettingTabBarActions {
    let showInformation: (String) -> Void
    let showLanguage: () -> Void
    let showShare: () -> Void
    let showRate: () -> Void
    let showPolicy: () -> Void
    let showChangePassword: () -> Void
    let showLogOut: () -> Void
    let showHomeTabBar: () -> Void
    let showSearchTabBar: () -> Void
}

protocol SettingTabBarViewModelInput {
    func viewDidLoad()
    func openInformation(studentCode: String)
    func openLanguage()
    func openShare()
    func openRate()
    func openPolicy()
    func openChangePassword()
    func openLogOut()
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
    
    func openInformation(studentCode: String) {
        actions.showInformation(studentCode)
    }
    
    func openLanguage() {
        actions.showLanguage()
    }
    
    func openShare() {
        
    }
    
    func openRate() {
        
    }
    
    func openPolicy() {
        
    }
    
    func openChangePassword() {
        
    }
    
    func openLogOut() {
        
    }
    
    func openHomeTabBar() {
        actions.showHomeTabBar()
    }
    
    func openSearchTabBar() {
        actions.showSearchTabBar()
    }

}


