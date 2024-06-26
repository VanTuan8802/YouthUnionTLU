//
//  NewClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import Foundation
import FirebaseFirestore

protocol PostClient {
    associatedtype T
    
    func getPosts(majorId: String, postType: PostType, completion: @escaping ([PostModel]?,Error?) -> Void)
    
    func createPost(path: String, post: PostMock, pathImage: String, listContent: [ContentMock], completion: @escaping (Error?) -> Void)
    
    func createPostStorage(post: PostMock, completion: @escaping (String?, Error?) -> Void)
    
}
