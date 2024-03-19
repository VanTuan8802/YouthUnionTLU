//
//  PermisstionViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 14/03/2024.
//

import Foundation
import UIKit

struct PermissionActions{
    let showLogin: () -> Void
}

protocol PermissionViewModelInput{
    func viewDidLoad()
    func openLogin()
}

protocol PermissionViewModelOutput{
    
}

protocol PermissionViewModel: PermissionViewModelInput, PermissionViewModelOutput { }

class DefaultPermisstionViewModel: PermissionViewModel {
    
    private let actions: PermissionActions
    
    init(actions: PermissionActions) {
        self.actions = actions
    }
    
}

extension DefaultPermisstionViewModel {
    func viewDidLoad() {
        
    }
    
    func openLogin() {
        UserDefaultsData.shared.showPermission = true
        actions.showLogin()
    }
}
