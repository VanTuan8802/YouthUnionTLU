//
//  AppDIContainer.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation

final class AppDIContainer {
    func makeOnboardDIContainer() -> OnboardDIContainer {
        let dependencies = OnboardDIContainer.Dependencies(a: "kf")
        return OnboardDIContainer(dependencies: dependencies)
    }
}
