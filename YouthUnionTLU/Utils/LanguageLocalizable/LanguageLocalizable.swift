//
//  LanguageLocalizable.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 11/03/2024.
//

import Foundation

extension _R {
    var stringLocalizable: string.localizable {
        R.string.localizable(preferredLanguages: [UserDefaultsData.shared.language.rawValue])
    }
}
