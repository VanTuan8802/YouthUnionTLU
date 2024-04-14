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
    
    func getPossionUser(id: String, completion: @escaping(Position?,Error?) -> Void)
    func getDataUser(id: String, completion: @escaping(T?,Error?) -> Void)
}
