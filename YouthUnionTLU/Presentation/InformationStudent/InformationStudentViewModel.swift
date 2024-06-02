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
        FSUserClient.shared.getDataStudent(studentCode: studentCode) {
            profileStudent, error in
            guard let profileStudent = profileStudent ,
                  error == nil else {
                self.error.value = error?.localizedDescription
                return
            }
            self.profileStudent.value = profileStudent
        }
        
        getListStudent {
            guard let listStudents = self.listStudent.value else {
                return
            }
            
            if !listStudents.contains(self.studentCode) {
                self.error.value = "Nodata"
            } else {
                self.getDataStudent(studentCode: self.studentCode) {
                    self.getListClass(uid: self.uid ?? "") {
                        guard let studentClass = self.profileStudent.value?.className ,
                              let listClasss = self.listClass.value else {
                            return
                        }
                        
                        if !listClasss.contains(studentClass) {
                            self.error.value = "No data"
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
    
    private func getListClass(uid: String, completion: @escaping() -> Void) {
        FSUserClient.shared.getListClass(uid: Auth.auth().currentUser?.uid ?? "") { classes, error in
            guard let classes = classes,
                    error == nil else {
                self.error.value = error?.localizedDescription
                return
            }
            self.listClass.value = classes
            completion()
        }
    }
    
    private func getListStudent(completion: @escaping() -> Void) {
        FSUserClient.shared.getListStudent { studentes, error in
            guard let studentes = studentes,
                  error == nil else {
                self.error.value = error?.localizedDescription
                return
            }
            self.listStudent.value = studentes
            completion()
        }
    }

    private func getDataStudent(studentCode: String, completion: @escaping () -> Void) {
        FSUserClient.shared.getDataStudent(studentCode: studentCode) { profileStudent, error in
            guard let profileStudent = profileStudent ,
                  error == nil else {
                self.error.value = error?.localizedDescription
                return
            }
            print(profileStudent)
            self.profileStudent.value = profileStudent
        }
        completion()
    }
}
