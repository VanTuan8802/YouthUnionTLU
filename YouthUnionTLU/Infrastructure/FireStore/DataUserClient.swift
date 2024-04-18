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
    
    func getPossionUser(uid: String, completion: @escaping(Position?,Error?) -> Void)
    func getDataUser(uid: String, completion: @escaping(T?,Error?) -> Void)
}
