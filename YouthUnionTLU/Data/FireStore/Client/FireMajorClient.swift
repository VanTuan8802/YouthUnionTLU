//
// FireMajorClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 28/5/24.
//

import Foundation
import FirebaseFirestore

class FSMajoyClient: MajorClient {
    
    static let shared = FSMajoyClient()
    
    private let database = Firestore.firestore()
    
    func getDataMajor(majorId: String, completion: @escaping (Major?, Error?) -> Void) {
        self.database.collection(CollectionFireStore.majores.rawValue)
            .document(majorId)
            .getDocument(as: Major.self) { result in
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
    
    func getListMajorId(completion: @escaping ([String]?, Error?) -> Void) {
        var listMajorId: [String] = []
        let dispatchGroup = DispatchGroup()
        
        database.collection(CollectionFireStore.majores.rawValue).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {
                let error = NSError(domain: "Snapshot Error", code: -1, userInfo: nil)
                completion(nil, error)
                return
            }
            
            for document in snapshot.documents {
                dispatchGroup.enter()
                listMajorId.append(document.documentID)
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(listMajorId, nil)
            }
        }
    }
    
    func getListMajor(completion: @escaping ([Major]?, Error?) -> Void) {
        var dataMajor: [Major] = []
        let dispatchGroup = DispatchGroup()
        
        database.collection(CollectionFireStore.majores.rawValue)
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
                    
                    self.getDataMajor(majorId: snapshot.documentID) { major, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let major = major {
                            dataMajor.append(major)
                        } else if let error = error {
                            print("Error fetching major: \(error)")
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(dataMajor, nil)
                }
            }
    }
}

