//
//  SearchManager.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 30/5/24.
//

import Foundation
import FirebaseAuth

class SearchManager {
    static let shared = SearchManager()
    
    func checkStudentCode(studentCode: String, profileStudent: ProfileStudent?, completion: @escaping(Bool) -> Void) {
        FSUserClient.shared.getListStudent { studentes, error in
            guard let studentes = studentes,
                  error == nil,
                  studentes.contains(studentCode)  else {
                completion(false)
                return
            }
            
            if UserDefaultsData.shared.posision == Position.member.rawValue {
                completion(true)
            } else {
                FSUserClient.shared.getListClass(uid: Auth.auth().currentUser?.uid ?? "") { classes, error in
                    guard let classes = classes,
                          error == nil,
                          let profileStudent = profileStudent else {
                        completion(false)
                        return
                    }
                    
                    completion(classes.contains(profileStudent.className))
                }
            }
        }
    }
    
}
