//
//  PositionStudent.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 25/4/24.
//

import Foundation

struct PositionStudent: Decodable {
    var position: String
    var student_Code: String?
    
    init(position: String, student_Code: String? = nil) {
        self.position = position
        self.student_Code = student_Code
    }
}
