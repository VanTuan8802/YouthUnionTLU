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
    case lao = "lo-LA"
    case cam = "km-KH"
    
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
            return R.stringLocalizable.languageVie()
        case .eng:
            return R.stringLocalizable.languageEng()
        case .fre:
            return R.stringLocalizable.languageFre()
        case .lao:
            return R.stringLocalizable.languageLao()
        case .cam:
            return R.stringLocalizable.languageCam()
        }
    }
}
