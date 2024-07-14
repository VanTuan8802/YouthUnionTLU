//
//  FSNewClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import Foundation
import FirebaseFirestoreInternal

class FSPostClient: PostClient {

    
    typealias T = PostModel
    
    static let shared = FSPostClient()
    
    private let database = Firestore.firestore()
    
    func getPosts(majorId: String,
                  postType: PostType,
                  completion: @escaping ([PostModel]?, Error?) -> Void) {
        var listNews: [PostModel] = []
        let dispatchGroup = DispatchGroup()
        
        self.database.collection("\(postType)_\(majorId)")
            .limit(to: 50)
            .addSnapshotListener { snapShot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let snapShots = snapShot else {
                    let error = NSError(domain: "Snapshot Error", code: -1, userInfo: nil)
                    completion(nil, error)
                    return
                }
                
                listNews.removeAll()
                
                for snapshot in snapShots.documents {
                    dispatchGroup.enter()
                    
                    self.getPost(posType: postType,
                                 majorId: majorId,
                                 postId: snapshot.documentID) { new, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let new = new {
                            listNews.append(new)
                        } else if let error = error {
                            print("Error fetching news: \(error)")
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(listNews, nil)
                }
            }
    }
    
    func createPost(path: String,
                    post: PostMock,
                    pathImage: String,
                    listContent: [ContentMock],
                    completion: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        guard let postId = post.id else {
            completion(NSError(domain: "NewModelMock",
                               code: -1,
                               userInfo: [NSLocalizedDescriptionKey: "Invalid NewModelMock id"]))
            return
        }
        
        var postModel: PostModel
        
        if post.postType == .new {
            postModel = PostModel(id: postId,
                                  imageNew: pathImage,
                                  title: post.title,
                                  timeCreate: post.timeCreate,
                                  postType: post.postType)
        } else {
            postModel = PostModel(id: postId,
                                  imageNew: pathImage,
                                  title: post.title,
                                  timeCreate: post.timeCreate,
                                  postType: post.postType,
                                  address: post.address,
                                  timeStartActivy: post.timeStart,
                                  timeChecIn: post.timeCheckIn,
                                  qrCode: post.qrText)
        }
        
        dispatchGroup.enter()
        database.collection(path)
            .document(postId)
            .setData(postModel.dictionary) { error in
                if let error = error {
                    print("Failed to set data: \(error.localizedDescription)")
                    completion(error)
                }
                dispatchGroup.leave()
            }
        
        for index in 0..<listContent.count {
            let content = listContent[index]
            
            dispatchGroup.enter()
            
            if content.contentType == .text {
                let contentModel = ContentModel(
                    contentNumber: index,
                    textContent: content.textContent,
                    contentType: .text
                )
                self.addContent(path: path,
                                postId: postId,
                                content: contentModel) { error in
                    if let error = error {
                        print("Failed to add text content: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            } else if content.contentType == .image {
                guard let image = content.imageContent else {
                    dispatchGroup.leave()
                    completion(NSError(domain: "ContentModelMock",
                                       code: -1,
                                       userInfo: [NSLocalizedDescriptionKey: "Invalid image content"]))
                    return
                }
                
                FSStorageClient.shared.uploadImage(index: index, image: image,
                                                   path: "\(post.postType)/\(postId)") { result in
                    switch result {
                    case .success(let downloadURL):
                        let contentModel = ContentModel(
                            contentNumber: index,
                            imageContent: downloadURL,
                            contentType: .image
                        )
                        
                        print(downloadURL)
                        self.addContent(path: path,
                                        postId: postId,
                                        content: contentModel) { error in
                            if let error = error {
                                print("Failed to add image content: \(error.localizedDescription)")
                            }
                            dispatchGroup.leave()
                        }
                    case .failure(let error):
                        print("Failed to upload image: \(error.localizedDescription)")
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            LoadingView.hide()
            completion(nil)
        }
    }

    
    func createPostStorage(post: PostMock,
                           completion: @escaping (String?, Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        FSStorageClient.shared.uploadImage(
            index: nil, image: post.imageNew,
            path: "\(post.postType)/\(String(describing: post.id))",
            completion: { result in
                dispatchGroup.leave()
                switch result {
                case .success(let path):
                    completion(path, nil)
                case .failure(let error):
                    completion(nil,error)
                    print("Failed to upload image: \(error.localizedDescription)")
                }
            }
        )
    }
    
    func joinActivity(postId: String, joinActivity: JoinActivityModel, completion: @escaping (Error?) -> Void) {
        self.database.collection(CollectionFireStore.joinActivity.rawValue)
            .document(UserDefaultsData.shared.studentCode)
            .collection(CollectionFireStore.listActivity.rawValue)
            .document(postId)
            .setData(joinActivity.dictionary) { error in
                completion(error)
            }
    }
    
    
    
    private func addContent(path:String,
                            postId: String,
                            content: ContentModel,
                            completion: @escaping (Error?) -> Void ) {
        self.database.collection(path)
            .document(postId)
            .collection(CollectionFireStore.listContent.rawValue)
            .addDocument(data: content.dictionary) { error in
                
                completion(error)
            }
    }
    
    func getListContent(majorId: String,
                        post: PostModel,
                        completion: @escaping ([ContentModel]?, Error?) -> Void) {
        var listContent:[ContentModel] = []
        let dispatchGroup = DispatchGroup()
        
        guard let postId = post.id else {
            return
        }
        
        self.database.collection("\(post.postType)_\(majorId)")
            .document(postId)
            .collection(CollectionFireStore.listContent.rawValue)
            .getDocuments { snapShot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let snapShots = snapShot else {
                    let error = NSError(domain: "Snapshot Error", code: -1, userInfo: nil)
                    completion(nil, error)
                    return
                }
                
                for snapshot in snapShots.documents {
                    dispatchGroup.enter()
                    
                    self.getContent(majorId: majorId,
                                    postId: postId,
                                    postType: post.postType,
                                    contentId: snapshot.documentID) { content, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let content = content {
                            listContent.append(content)
                        } else if let error = error {
                            print("Error fetching major: \(error)")
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(listContent, nil)
                }
            }
    }
    
     func getPost(posType: PostType,
                         majorId: String,
                         postId: String,
                         completion: @escaping (PostModel?, Error?) -> Void) {
        self.database.collection("\(posType)_\(majorId)")
            .document(postId)
            .getDocument(as: PostModel.self) { result in
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    var errorMessage = "Error decoding document: \(error.localizedDescription)"
                    if case let DecodingError.typeMismatch(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.valueNotFound(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.keyNotFound(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.dataCorrupted(key) = error {
                        errorMessage = "\(error.localizedDescription): \(key)"
                    }
                    completion(nil, error)
                }
            }
    }
    
     func getContent(majorId: String,
                            postId: String,
                            postType: PostType,
                            contentId: String,
                            completion: @escaping (ContentModel?, Error?) -> Void) {
        self.database.collection("\(postType)_\(majorId)")
            .document(postId)
            .collection(CollectionFireStore.listContent.rawValue)
            .document(contentId)
            .getDocument(as: ContentModel.self) { result in
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    var errorMessage = "Error decoding document: \(error.localizedDescription)"
                    if case let DecodingError.typeMismatch(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.valueNotFound(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.keyNotFound(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.dataCorrupted(key) = error {
                        errorMessage = "\(error.localizedDescription): \(key)"
                    }
                    completion(nil, error)
                }
            }
    }
    
    private func getPostActivity(major: String,
                                 postActivityId: String,
                                 completion: @escaping (ActivityModel?,Error?) -> Void) {
        self.database.collection("\(CollectionFireStore.activities.rawValue)_\(major)")
            .document(postActivityId)
            .getDocument(as: ActivityModel.self) { result in
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    var errorMessage = "Error decoding document: \(error.localizedDescription)"
                    if case let DecodingError.typeMismatch(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.valueNotFound(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.keyNotFound(_, context) = error {
                        errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    } else if case let DecodingError.dataCorrupted(key) = error {
                        errorMessage = "\(error.localizedDescription): \(key)"
                    }
                    completion(nil, error)
                }
            }
    }
}
