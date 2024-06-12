//
//  NewClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import Foundation
import FirebaseFirestore

protocol NewClient {
    associatedtype T
    
    func getNews(uid: String, completion: @escaping ([NewModel]?,Error?) -> Void)
    
    func getListContent(newId: String, completion: @escaping ([ContentModel]?,Error?) -> Void)
}
