//
//  File.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 28/5/24.
//

import Foundation
import FirebaseFirestore

struct Major: Decodable {
    @DocumentID var id: String?
    var name: String
}
