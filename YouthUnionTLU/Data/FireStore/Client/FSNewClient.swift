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
    
    func getNews(uid: String, completion: @escaping ([NewModel]?, Error?) -> Void) {
        var listNews: [NewModel] = []
        let dispatchGroup = DispatchGroup()
        
        self.database.collection(CollectionFireStore.new.rawValue)
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
                    
                    self.getNew(newId: snapshot.documentID) { new, error in
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


    func getListContent(newId: String, completion: @escaping ([ContentModel]?, Error?) -> Void) {
        var listContent:[ContentModel] = []
        let dispatchGroup = DispatchGroup()
        
        self.database.collection(CollectionFireStore.new.rawValue)
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
                    
                    self.getContent(newId: newId, contentId: snapshot.documentID) { content, error in
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
    
    private func getNew(newId: String, completion: @escaping (NewModel?, Error?) -> Void) {
        self.database.collection(CollectionFireStore.new.rawValue)
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
    
    
    private func getContent(newId: String, contentId: String, completion: @escaping (ContentModel?, Error?) -> Void) {
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
    
}
