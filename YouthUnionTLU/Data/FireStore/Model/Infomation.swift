//
//  Infomation.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 17/05/2024.
//

import Foundation

struct Information: Decodable {
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
