//
//  ExtentionDictionary.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 17/6/24.
//

import Foundation

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    var dictionary: [String: Any] {
        do {
            let data = try JSON.encoder.encode(self)
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                  let dictionary = jsonObject as? [String: Any] else {
                return [:]
            }
            return dictionary
        } catch let error {
            return [:]
        }
    }
    
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
}
