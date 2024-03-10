//
//  SplashViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation

struct SplashActions {
    let showFirstLanguage: () -> Void
    let showIntro: () -> Void
}

protocol SplashViewModelInput {
    func viewDidLoad()
    func openFirstLanguage()
    func openIntro()
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
       
    }
    
    func openIntro() {
        
    }
}
