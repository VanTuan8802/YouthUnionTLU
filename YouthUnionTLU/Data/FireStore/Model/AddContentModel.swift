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

struct NewModelMock {
    var id: String?
    var imageNew: UIImage
    var title: String
    var timeCreate: Timestamp
}

struct ContentModelMock {
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
