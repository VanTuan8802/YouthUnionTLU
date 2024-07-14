//
//  ChangePasswordViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 9/7/24.
//

import Foundation

struct ChangePasswordActions {
    let showLogin: () -> Void
}

protocol ChangePasswordViewModelInput {
    func viewDidLoad()
    func openShowLogin()
}

protocol ChangePasswordViewModelOutput {
    var error: Observable<String?> {get}
}

protocol ChangePasswordViewModel: ChangePasswordViewModelInput, ChangePasswordViewModelOutput {
    
}

class DefaultChangePasswordViewModel: ChangePasswordViewModel {
    
    var error: Observable<String?> = Observable(nil)
    
    private let actions: ChangePasswordActions?
    
    init( actions: ChangePasswordActions?) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        
    }
    
    func openShowLogin() {
        actions?.showLogin()
    }
    
}
