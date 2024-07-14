//
//  hashCode.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 12/7/24.
//

import Foundation
import CryptoKit

func sha256Hash(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}
