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
    func getDataProfile(studentCode: String, completion: @escaping (PersionalInformation?, Error?) -> Void)
    func getDataStudent(studentCode: String, completion: @escaping (StudentInformation?, Error?) -> Void)
}
