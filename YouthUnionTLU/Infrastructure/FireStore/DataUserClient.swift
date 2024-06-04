//
//  DataUserClient.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import FirebaseFirestore

protocol UserClient {
    associatedtype T
    
    func getPossionUser(uid: String, completion: @escaping(PositionStudent?,Error?) -> Void)
    func getDataStudent(studentCode: String, completion: @escaping (ProfileStudent?, Error?) -> Void)
    func getListClass(uid: String, completion: @escaping([String]?,Error?) -> Void)
    func getListStudent(completion: @escaping([String]?,Error?) -> Void)
}
