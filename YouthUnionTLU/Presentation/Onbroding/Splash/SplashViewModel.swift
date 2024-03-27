//
//  SplashViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation

struct SplashActions {
    let showFirstLanguage: () -> Void
    let showPermission: () -> Void
    let showLogin: () -> Void
    let showHome: () -> Void
}

protocol SplashViewModelInput {
    func viewDidLoad()
    func openFirstLanguage()
    func openPermission()
    func openLogin()
}

protocol SplashViewModelOutput {
}

protocol SplashViewModel: SplashViewModelInput, SplashViewModelOutput { }

class DefaultSplashViewModel: SplashViewModel {
    
    private let actions: SplashActions?
    
    init(actions: SplashActions?) {
        self.actions = actions
    }
}

extension DefaultSplashViewModel {
    func viewDidLoad() { }
    
    func openFirstLanguage() {
        if !UserDefaultsData.shared.showFirstLanguage {
            actions?.showFirstLanguage()
        } else {
            if !UserDefaultsData.shared.showPermission {
                actions?.showPermission()
            } else {
                if UserDefaultsData.shared.showLogin {
                    actions?.showHome()
                } else {
                    actions?.showLogin()
                }
            }
        }
    }
    
    func openPermission() {
        actions?.showPermission()
    }
    
    func openLogin() {
        
    }
}
