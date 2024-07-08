//
//  SearchJoinActivityViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 3/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct SearchJoinActivityActions {
    let showSearchInformation: () -> Void
}

protocol SearchJoinActivityViewModelInput {
    func viewDidLoad()
    func openSearchInformation()
}

protocol SearchJoinActivityViewModelOutput {
    var error: Observable<String?> {get}
    var listJoinActivity: Observable<[JoinActivityModel]?> {get}
    var profileStudent: Observable<ProfileStudent?> {get}
}

protocol SearchJoinActivityViewModel: SearchJoinActivityViewModelInput, SearchJoinActivityViewModelOutput {
    
}

class DefaultSearchJoinActivityViewModel: SearchJoinActivityViewModel {
    private let uid = Auth.auth().currentUser?.uid
    
    var error: Observable<String?> = Observable(nil)
    var profileStudent: Observable<ProfileStudent?> = Observable(nil)
    var listJoinActivity: Observable<[JoinActivityModel]?>  = Observable([])
    
    private let actions: SearchJoinActivityActions?
    private let studentCode: String
    private let seachType: SearchType
    
    init(actions: SearchJoinActivityActions?, studentCode: String, searchType: SearchType) {
        self.actions = actions
        self.studentCode = studentCode
        self.seachType = searchType
    }
    
    init(actions: SearchJoinActivityActions?, studentCode: String) {
        self.actions = actions
        self.studentCode = studentCode
        self.seachType = .searchInfomationStudent
    }
    
    func viewDidLoad() {
        if UserDefaultsData.shared.posision == Position.manager.rawValue {
            self.getDataStudent(studentCode: self.studentCode) {
            }
            self.getListSearchJoinActivity(studentCode: self.studentCode) {
            }
        } else {
            getDataStudent(studentCode: studentCode) {
                SearchManager.shared.checkStudentCode(studentCode: self.studentCode,
                                                      profileStudent: self.profileStudent.value) { isTrue in
                    if !isTrue {
                        self.error.value = "No data"
                    } else {
                        self.getDataStudent(studentCode: self.studentCode) {
                        }
                        self.getListSearchJoinActivity(studentCode: self.studentCode) {
                        }
                    }
                }
            }
        }
    }
    
    func openSearchInformation() {
        
    }
    
    private func getDataStudent(studentCode: String, completion: @escaping () -> Void) {
        FSUserClient.shared.getDataStudent(studentCode: studentCode) { profileStudent, error in
            if let error = error {
                self.error.value = error.localizedDescription
                completion()
                return
            }
            
            if let profileStudent = profileStudent {
                self.profileStudent.value = profileStudent
            } else {
                self.error.value = "No profile found"
            }
            
            completion()
        }
    }
    
    private func getListSearchJoinActivity(studentCode: String, completion: @escaping () -> Void) {
        FSUserClient.shared.getListDataJoinActivity(studentCode: studentCode) { listJoinActivity, error in
            guard let listJoinActivity = listJoinActivity,
                  error == nil else {
                self.error.value = error?.localizedDescription
                completion()
                return
            }
            print(listJoinActivity)
            self.listJoinActivity.value = listJoinActivity
        }
        completion()
    }
}

