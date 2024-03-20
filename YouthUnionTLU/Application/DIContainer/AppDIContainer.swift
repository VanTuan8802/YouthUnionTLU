//
//  AppDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation

final class AppDIContainer {
    
    lazy var authClient = FSFireAuthClient()
    
    func makeOnboardDIContainer() -> OnboardDIContainer {
        let dependencies = OnboardDIContainer.Dependencies(a: "")
        return OnboardDIContainer(dependencies: dependencies)
    }
    
    func makeAuthenDIContainer() -> AuthenDIContainer {
        let dependencies = AuthenDIContainer.Dependencies(authClient: authClient )
        return AuthenDIContainer(dependencies: dependencies)
    }
}
