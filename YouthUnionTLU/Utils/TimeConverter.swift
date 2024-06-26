//
//  TimeConverter.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import Foundation
import FirebaseFirestoreInternal


func convertTimestampToString(timestamp: Timestamp) -> String {
    let format: String = "yyyy-MM-dd HH:mm"
    
    let date = timestamp.dateValue()

    let dateFormatter = DateFormatter()
    
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    dateFormatter.dateFormat = format
    
    let dateString = dateFormatter.string(from: date)
    
    return dateString
}

