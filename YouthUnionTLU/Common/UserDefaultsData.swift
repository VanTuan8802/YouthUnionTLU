//
//  UserDefaultsData.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 11/03/2024.
//

import Foundation

class UserDefaultsData {
    
    static let shared = UserDefaultsData()
    private let data = UserDefaults.standard
    
    enum Datakey: String {
        case firstLanguage
        case intro
        case permission
        case login
        case home
        case language
        case hashPass
    }
    
    var language: LanguageType {
        get {
            guard let language = data.string(forKey: Datakey.language.rawValue) else {
                let defaultLanguage = LanguageType.eng.rawValue
                data.set(defaultLanguage, forKey: Datakey.language.rawValue)
                return LanguageType(rawValue: defaultLanguage) ?? .eng
            }
            return LanguageType(rawValue: language) ?? .eng
        }
        set {
            data.set(newValue.rawValue, forKey: Datakey.language.rawValue)
        }
    }

    var hashPass: String {
        get {
            return data.string(forKey: Datakey.hashPass.rawValue) ?? ""
        }
        set {
            data.set(newValue, forKey: Datakey.hashPass.rawValue)
        }
    }

    var showFirstLanguage: Bool {
        get {
            return data.bool(forKey: Datakey.firstLanguage.rawValue)
        }
        set {
            data.set(newValue, forKey: Datakey.firstLanguage.rawValue)
        }
    }
    
    var showIntro: Bool {
        get {
            return data.bool(forKey: Datakey.intro.rawValue)
        }
        set {
            data.set(newValue, forKey: Datakey.intro.rawValue)
        }
    }
    
    var showPermission: Bool {
        get {
            return data.bool(forKey: Datakey.permission.rawValue)
        }
        set {
            data.set(newValue, forKey: Datakey.permission.rawValue)
        }
    }
    
    var showLogin: Bool {
        get {
            return data.bool(forKey: Datakey.login.rawValue)
        }
        set {
            data.set(newValue, forKey: Datakey.login.rawValue)
        }
    }
    
    var showHome: Bool {
        get {
            return data.bool(forKey: Datakey.home.rawValue)
        }
        set {
            data.set(newValue, forKey: Datakey.home.rawValue)
        }
    }
}
