//
//  InformationStudentViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 19/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct InformationStudentActions {
    let showSearchInformation: () -> Void
    let showSetting: () -> Void
}

protocol InformationStudentViewModelInput {
    func viewDidLoad()
    func openSearchInformation()
    func openSetting()
}

protocol InformationStudentViewModelOutput {
    var error: Observable<String?> {get}
    var listClass: Observable<[String]?> {get}
    var profileStudent: Observable<ProfileStudent?> {get}
    var listStudent: Observable<[String]?> {get}
}

protocol InformationStudentViewModel: InformationStudentViewModelInput, InformationStudentViewModelOutput {
    
}

class DefaultInformationStudentViewModel: InformationStudentViewModel {
    private let uid = Auth.auth().currentUser?.uid
    
    var error: Observable<String?> = Observable(nil)
    var profileStudent: Observable<ProfileStudent?> = Observable(nil)
    var listClass: Observable<[String]?> = Observable([])
    var listStudent: Observable<[String]?> = Observable([])
    
    private let actions: InformationStudentActions?
    private let studentCode: String
    private let seachType: SearchType
    
    init(actions: InformationStudentActions?, studentCode: String, searchType: SearchType) {
        self.actions = actions
        self.studentCode = studentCode
        self.seachType = searchType
    }
    
    init(actions: InformationStudentActions?, studentCode: String) {
        self.actions = actions
        self.studentCode = studentCode
        self.seachType = .searchInfomatioStudent
    }
    
    func viewDidLoad() {
        if UserDefaultsData.shared.posision == Position.manager.rawValue {
            self.getDataStudent(studentCode: self.studentCode) {
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
                    }
                }
            }
        }
    }
    
    func openSearchInformation() {
        
    }
    
    func openSetting() {
        
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
}
