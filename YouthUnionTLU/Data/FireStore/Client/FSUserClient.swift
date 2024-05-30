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
    
    typealias T = ProfileStudent
    
    static let shared = FSUserClient()
    
    private let database = Firestore.firestore()
    
    func getPossionUser(uid: String, completion: @escaping (PositionStudent?, Error?) -> Void) {
        database.collection(CollectionFireStore.userCollection.rawValue)
            .document(uid)
            .getDocument(as: PositionStudent.self) { result in
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
    
    func getDataProfile(studentCode: String, completion: @escaping (PersionalInformation?, Error?) -> Void) {
        database.collection(CollectionFireStore.profileCollection.rawValue)
            .document(studentCode)
            .collection(CollectionFireStore.persionalInfor.rawValue)
            .getDocuments { document, error in
                
                guard let persionalDocument = document?.documents.first?.documentID else {
                    return
                }
                
                self.database.collection(CollectionFireStore.persionalInfor.rawValue)
                    .document(persionalDocument)
                    .getDocument(as: PersionalInformation.self) { result in
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
    }
    
    func getDataStudent(studentCode: String, completion: @escaping (StudentInformation?, Error?) -> Void) {
        database.collection(CollectionFireStore.profileCollection.rawValue)
            .document(studentCode)
            .collection(CollectionFireStore.studentInfor.rawValue)
            .getDocuments { document, error in
                
                guard let studentDocument = document?.documents.first?.documentID else {
                    return
                }
                self.database.collection(CollectionFireStore.studentInfor.rawValue)
                    .document(studentDocument)
                    .getDocument(as: StudentInformation.self) { result in
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
    }
}
