//
//  AppDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation

final class AppDIContainer {
    
    lazy var authClient = FSFireAuthClient()
    lazy var userClient = FSUserClient()
    
    func makeOnboardDIContainer() -> OnboardDIContainer {
        let dependencies = OnboardDIContainer.Dependencies(a: "")
        return OnboardDIContainer(dependencies: dependencies)
    }
    
    func makeAuthenDIContainer() -> AuthenDIContainer {
        let dependencies = AuthenDIContainer.Dependencies(authClient: authClient )
        return AuthenDIContainer(dependencies: dependencies)
    }
    
    func makeHomeDIContainer() -> HomeDIContainer {
        let dependencies = HomeDIContainer.Dependencies(userClient: userClient)
        return HomeDIContainer(dependencies: dependencies)
    }
    
    func makeSearchDIContainer() -> SearchDIContainer {
        let dependencies = SearchDIContainer.Dependencies(userClient: userClient)
        return SearchDIContainer(dependencies: dependencies)
    }
    
    func makeSettingDIContainer() -> SettingDIContainer {
        let dependencies = SettingDIContainer.Dependencies(userClient: userClient)
        return SettingDIContainer(dependencies: dependencies)
    }
}
