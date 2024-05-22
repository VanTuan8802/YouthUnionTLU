//
//  LanguageViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 11/03/2024.
//

import Foundation

struct LanguageActions {
    let showPermission: () -> Void
    let showLogin: () -> Void
    let showHome: () -> Void
}

protocol LanguageViewModelInput {
    func viewDidLoad()
    func openPermisstion()
    func openHome()
}

protocol LanguageViewModelOutput {
    
}

protocol LanguageViewModel: LanguageViewModelInput, LanguageViewModelOutput { }

class DefaultLanguageViewModel: LanguageViewModel {
    
    private let actions: LanguageActions?

    init(actions: LanguageActions?) {
        self.actions = actions
    }
}

extension DefaultLanguageViewModel {
    func viewDidLoad() {
        
    }
    
    func openPermisstion() {
        UserDefaultsData.shared.showFirstLanguage = true
        if !UserDefaultsData.shared.showPermission {
            actions?.showPermission()
        } else {
            actions?.showLogin()
        }
    }
    
    func openHome() {
        actions?.showHome()
    }
}

