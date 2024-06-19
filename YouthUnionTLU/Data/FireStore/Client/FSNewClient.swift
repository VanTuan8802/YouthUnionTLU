//
//  FSNewClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import Foundation
import FirebaseFirestoreInternal

class FSNewClient: NewClient {
    
    typealias T = NewModel
    
    static let shared = FSNewClient()
    
    private let database = Firestore.firestore()
    
    func getNews(majorId: String,
                 completion: @escaping ([NewModel]?, Error?) -> Void) {
        var listNews: [NewModel] = []
        let dispatchGroup = DispatchGroup()
        
        self.database.collection("\(CollectionFireStore.new.rawValue)_\(majorId)")
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
                    
                    self.getNew(majorId: majorId, newId: snapshot.documentID) { new, error in
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
    
    func getListPostActivity(major: String,
                             completion: @escaping ([ActivityModel]?, Error?) -> Void) {
        var listPostActivity:[ActivityModel] = []
        let dispatchGroup = DispatchGroup()
        
        self.database.collection("\(CollectionFireStore.activities.rawValue)_\(major)")
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
                
                listPostActivity.removeAll()
                
                for snapshot in snapShots.documents {
                    dispatchGroup.enter()
                    
                    self.getPostActivity(major: major,
                                         postActivityId: snapshot.documentID) { postActivity, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let postActivity = postActivity {
                            listPostActivity.append(postActivity)
                        } else if let error = error {
                            print("Error fetching news: \(error)")
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(listPostActivity, nil)
                }
            }
    }
    
    func createNew(path: String,
                   new: NewModelMock,
                   pathImage: String,
                   listContent: [ContentModelMock],
                   completion: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        guard let newId = new.id else {
            completion(NSError(domain: "NewModelMock",
                               code: -1,
                               userInfo: [NSLocalizedDescriptionKey: "Invalid NewModelMock id"]))
            return
        }
        
        
        let newModel = NewModel(imageNew: pathImage,
                                title: new.title,
                                timeCreate: new.timeCreate)
        
        
        database.collection(path)
            .document(newId)
            .setData(newModel.dictionary, completion: { error in
                if let error = error {
                    print("Failed to set data: \(error.localizedDescription)")
                    completion(error)
                    return
                }
            })
        
        for index in 0..<listContent.count {
            let content = listContent[index]
            
            dispatchGroup.enter()
            
            if content.contentType == .text {
                let contentModel = ContentModel(
                    contentNumber: index,
                    textContent: content.textContent,
                    contentType: .text
                )
                self.addContent(path: path, newId: newId, content: contentModel) { error in
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
                
                FSStorageClient.shared.uploadImage(image: image, path: "\(CollectionFireStore.new.rawValue)\(newId)") { result in
                    switch result {
                    case .success(let downloadURL):
                        let contentModel = ContentModel(
                            contentNumber: index,
                            imageContent: downloadURL,
                            contentType: .image
                        )
                        self.addContent(path: path, newId: newId, content: contentModel) { error in
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
    
    func createNewStorage(new: NewModelMock,
                          completion: @escaping (String?, Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        FSStorageClient.shared.uploadImage(
            image: new.imageNew,
            path: "\(CollectionFireStore.new.rawValue)/\(String(describing: new.id))",
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
    
    private func addContent(path:String,
                            newId: String,
                            content: ContentModel,
                            completion: @escaping (Error?) -> Void ) {
        self.database.collection(path)
            .document(newId)
            .collection(CollectionFireStore.listContent.rawValue)
            .addDocument(data: content.dictionary) { error in
                
                completion(error)
            }
    }
    
    func getListContent(majorId: String,
                        newId: String,
                        completion: @escaping ([ContentModel]?, Error?) -> Void) {
        var listContent:[ContentModel] = []
        let dispatchGroup = DispatchGroup()
        
        self.database.collection("\(CollectionFireStore.new.rawValue)_\(majorId)")
            .document(newId)
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
                    
                    self.getContent(newId: newId,
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
    
    private func getNew(majorId: String,
                        newId: String,
                        completion: @escaping (NewModel?, Error?) -> Void) {
        self.database.collection("\(CollectionFireStore.new.rawValue)_\(majorId)")
            .document(newId)
            .getDocument(as: NewModel.self) { result in
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
    
    private func getContent(newId: String,
                            contentId: String, completion: @escaping (ContentModel?, Error?) -> Void) {
        self.database.collection(CollectionFireStore.new.rawValue)
            .document(newId)
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
    
    private func getPostActivity(major: String,postActivityId: String
                                 , completion: @escaping (ActivityModel?,Error?) -> Void) {
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
