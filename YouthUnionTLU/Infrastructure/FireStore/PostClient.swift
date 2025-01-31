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
    
    func getPost(posType: PostType,
                 majorId: String,
                 postId: String,
                 completion: @escaping (PostModel?, Error?) -> Void)
    
    func getPosts(majorId: String,
                  postType: PostType,
                  completion: @escaping ([PostModel]?,Error?) -> Void)
    
    func createPost(path: String, 
                    post: PostMock,
                    pathImage: String,
                    listContent: [ContentMock],
                    completion: @escaping (Error?) -> Void)
    
    func createPostStorage(post: PostMock, 
                           completion: @escaping (String?, Error?) -> Void)
    
    func getContent(majorId: String,
                    postId: String,
                    postType: PostType,
                    contentId: String,
                    completion: @escaping (ContentModel?, Error?) -> Void)
    
    func getListContent(majorId: String,
                        post: PostModel,
                        completion: @escaping ([ContentModel]?,Error?) -> Void )
    
    func joinActivity(postId: String,joinActivity: JoinActivityModel, completion: @escaping (Error?) -> Void )
}
