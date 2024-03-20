//
//  FireAuthClient.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import FirebaseAuth

class FSFireAuthClient : AuthClient {
    
    static var shared = FSFireAuthClient()
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}

