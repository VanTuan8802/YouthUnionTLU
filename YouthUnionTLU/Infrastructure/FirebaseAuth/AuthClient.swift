//
//  FirebaseAuthClient.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import FirebaseAuth

protocol AuthClient {
    func login(email: String, password: String, completion: @escaping(Error?) -> Void)
}
