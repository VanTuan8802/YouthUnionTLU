//
//  Teacher.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation

struct Teacher: Decodable {
    let id: String
    let name: String
    let avatarUrl: String
    let classManager: [String]
}
