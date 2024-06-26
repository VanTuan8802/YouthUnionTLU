//
//  AddContentModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 17/6/24.
//

import Foundation
import UIKit
import FirebaseFirestoreInternal
import FirebaseFirestore

struct PostMock {
    var id: String?
    var imageNew: UIImage
    var title: String
    var timeCreate: Timestamp
    var address: String?
    var timeStart: Timestamp?
    var timeCheckIn: Timestamp?
    var qrText: String?
    var postType: PostType
    var timeStartActivy: Timestamp?
    
    init(id: String? = nil, imageNew: UIImage, title: String, timeCreate: Timestamp, address: String? = nil, timeStart: Timestamp? = nil, timeCheckIn: Timestamp? = nil, qrText: String? = nil, postType: PostType, timeStartActivy: Timestamp? = nil) {
        self.id = id
        self.imageNew = imageNew
        self.title = title
        self.timeCreate = timeCreate
        self.address = address
        self.timeStart = timeStart
        self.timeCheckIn = timeCheckIn
        self.qrText = qrText
        self.postType = postType
        self.timeStartActivy = timeStartActivy
    }
}

struct ContentMock {
    var contentNumber: Int
    var textContent: String?
    var imageContent: UIImage?
    var contentType: ContentType
    
    init(contentNumber: Int, textContent: String? = nil, imageContent: UIImage? = nil, contentType: ContentType) {
        self.contentNumber = contentNumber
        self.textContent = textContent
        self.imageContent = imageContent
        self.contentType = contentType
    }
}
