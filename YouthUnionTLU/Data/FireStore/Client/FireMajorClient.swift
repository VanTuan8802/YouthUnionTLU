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
    
    func getDataMajoy(majorId: String, completion: @escaping (Major?, Error?) -> Void) {
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
                    print(errorMessage)
                    completion(nil, error)
                }
            }
    }
    
    func getListMajoy(completion: @escaping ([Major]?, Error?) -> Void) {
        var dataMajor: [Major] = []
        let dispatchGroup = DispatchGroup()
        
        database.collection(CollectionFireStore.majores.rawValue)
            .getDocuments { snapShot, error in
                if let error = error {
                    print(error)
                    completion(nil, error)
                    return
                }
                
                guard let snapShots = snapShot else {
                    let error = NSError(domain: "Snapshot Error", code: -1, userInfo: nil)
                    print(error)
                    completion(nil, error)
                    return
                }
                
                for snapshot in snapShots.documents {
                    dispatchGroup.enter()
                    
                    self.getDataMajoy(majorId: snapshot.documentID) { major, error in
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

