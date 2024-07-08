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
    
    func getDataStudent(studentCode: String, completion: @escaping (ProfileStudent?, Error?) -> Void) {
        database.collection(CollectionFireStore.profileCollection.rawValue)
            .document(studentCode)
            .getDocument(as: ProfileStudent.self) { result in
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
    
    func getDataPointTraining(studentCode: String, completion: @escaping ([PointTrainingYear]?, Error?) -> Void) {
        var listPoint: [PointTrainingYear] = []
        let dispatchGroup = DispatchGroup()
        
        database.collection(CollectionFireStore.pointTraining.rawValue)
            .document(studentCode)
            .collection(CollectionFireStore.pointes.rawValue)
            .getDocuments { snapshotData, error in
                guard let snapshotData = snapshotData, error == nil else {
                    completion(nil, error)
                    return
                }
                
                for year in snapshotData.documents {
                    dispatchGroup.enter()
                    self.getDataPointTrainingTerm(year: year.documentID, studentCode: studentCode) { pointTraning, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        guard let pointTraning = pointTraning, error == nil else {
                            completion(nil, error)
                            return
                        }
                        
                        let pointTraningYear = PointTrainingYear(year: year.documentID, points: pointTraning)
                        listPoint.append(pointTraningYear)
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(listPoint, nil)
                }
            }
    }
    
    private func getDataPointTrainingTerm(year: String, studentCode: String,completion: @escaping (PointTraining?, Error?) -> Void) {
        database.collection(CollectionFireStore.pointTraining.rawValue)
            .document(studentCode)
            .collection(CollectionFireStore.pointes.rawValue)
            .document(year)
            .getDocument(as: PointTraining.self) {result in
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
    
    func getListDataJoinActivity(studentCode: String, completion: @escaping ([JoinActivityModel]?, Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var listActivity: [JoinActivityModel] = []
        database.collection(CollectionFireStore.joinActivity.rawValue)
            .document(studentCode)
            .collection(CollectionFireStore.listActivity.rawValue)
            .getDocuments { data, error in
                guard let data = data,
                      error == nil else {
                    completion(nil,error)
                    return
                }
                
                for joinActivity in data.documents {
                    dispatchGroup.enter()
                    self.getDataJoinActivity(studentCode: studentCode,
                                             activityId: joinActivity.documentID) { joinActivity, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        guard let joinActivity = joinActivity, error == nil else {
                            completion(nil, error)
                            return
                        }
                        
                        listActivity.append(joinActivity)
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(listActivity, nil)
                }
            }
    }
    
    private func getDataJoinActivity(studentCode: String, activityId: String, completion: @escaping (JoinActivityModel?, Error?) -> Void) {
        database.collection(CollectionFireStore.joinActivity.rawValue)
            .document(studentCode)
            .collection(CollectionFireStore.listActivity.rawValue)
            .document(activityId)
            .getDocument(as: JoinActivityModel.self) {result in
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
    
    func getListClass(uid: String, completion: @escaping ([String]?, Error?) -> Void) {
        var listClass :[String] = []
        database.collection(CollectionFireStore.userCollection.rawValue)
            .document(uid)
            .collection(CollectionFireStore.classes.rawValue)
            .getDocuments { data, error in
                guard let data = data,
                      error == nil else {
                    completion(nil,error)
                    return
                }
                
                for className in data.documents {
                    listClass.append(className.documentID)
                }
                completion(listClass,nil)
            }
    }
    
    func getListStudent(completion: @escaping ([String]?, Error?) -> Void) {
        var listStudent: [String] = []
        database.collection(CollectionFireStore.profileCollection.rawValue)
            .getDocuments { data, error in
                guard let data = data,
                      error == nil else {
                    completion(nil,error)
                    return
                }
                
                
                for studentId in data.documents {
                    listStudent.append(studentId.documentID)
                }
                completion(listStudent,nil)
            }
    }
    
}
