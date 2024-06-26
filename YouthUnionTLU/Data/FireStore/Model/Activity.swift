//
//  Activity.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 12/6/24.
//

import Foundation
import FirebaseFirestoreInternal

struct ActivityModel: Decodable {
    var imageActivity: String
    var nameActivity: String
    var createPostActivity: Timestamp
    var timeCheckIn: Timestamp
    var timeCheckOut: Timestamp
    var qrCode: String
}