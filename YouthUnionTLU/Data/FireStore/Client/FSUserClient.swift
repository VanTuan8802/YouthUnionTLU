//
//  FSUserClient.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FSUserClient: UserClient {
    typealias T = User
    
    static let shared = FSUserClient()
    
    private let database = Firestore.firestore()
    
    func getPossionUser(uid: String, completion: @escaping (Position?, Error?) -> Void) {
        database.collection(CollectionFireStore.userCollection.rawValue)
            .document(uid)
            .getDocument { result, error in
                guard let result = result,
                      error == nil else {
                    completion(nil, error)
                    return
                }
                
                if let positionRawValue = result.data()?.values.first as? String,
                   let position = Position(rawValue: positionRawValue) {
                    completion(position, nil)
                } else {
                    completion(nil, NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid position value"]))
                }
            }
    }
    
    func getDataUser(uid: String, completion: @escaping (User?, Error?) -> Void) {
        
    }
}
