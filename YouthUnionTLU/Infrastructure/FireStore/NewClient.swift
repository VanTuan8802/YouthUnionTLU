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
    
    func getNews(majorId: String, completion: @escaping ([NewModel]?,Error?) -> Void)
    
    func getListContent(majorId: String, newId: String, completion: @escaping ([ContentModel]?,Error?) -> Void)
    
    func getListPostActivity(major: String, completion: @escaping ([ActivityModel]?,Error?) -> Void)
    
    func createNew(path: String, new: NewModelMock, pathImage: String, listContent: [ContentModelMock], completion: @escaping (Error?) -> Void)
    
    func createNewStorage(new: NewModelMock, completion: @escaping (String?, Error?) -> Void) 
    
}
