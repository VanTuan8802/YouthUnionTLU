//
//  LanguageType.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 11/03/2024.
//

import Foundation

enum LanguageType: String, Encodable {
    case vie = "vie"
    case eng = "eng"
    case fre = "fre"
    case lao = "lap=o"
    case cam = "cam"
    
    var image: String {
        switch self {
        case .vie:
           return R.image.vietNam.name
        case .eng:
            return R.image.english.name
        case .fre:
            return R.image.french.name
        case .lao:
            return R.image.laos.name
        case .cam:
            return R.image.cambodian.name
        }
    }
    
    var name: String {
        switch self {
        case .vie:
            return R.string.localizable.languageVie()
        case .eng:
            return R.string.localizable.languageEng()
        case .fre:
            return R.string.localizable.languageFre()
        case .lao:
            return R.string.localizable.languageLao()
        case .cam:
            return R.string.localizable.languageCam()
        }
    }
}
