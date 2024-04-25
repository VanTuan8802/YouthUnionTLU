//
//  Profile.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import FirebaseFirestore

struct User: Decodable {
    @DocumentID var uid: String?
    var student: ProfileStudent?
    var teacher: Teacher?
    var faculaty: Faculaty?
    var manager: Manager?
    var posstion: Position
}
