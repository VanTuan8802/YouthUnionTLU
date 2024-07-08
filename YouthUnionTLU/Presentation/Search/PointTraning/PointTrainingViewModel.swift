//
//  PointTrainingViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 5/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PointTrainingActions {
    let showSearchInformation: () -> Void
}

protocol PointTrainingViewModelInput {
    func viewDidLoad()
    func openSearchInformation()
}

protocol PointTrainingViewModelOutput {
    var error: Observable<String?> {get}
    var listPoint: Observable<[PointTrainingYear]?> {get}
    var profileStudent: Observable<ProfileStudent?> {get}
}

protocol PointTrainingViewModel: PointTrainingViewModelInput, PointTrainingViewModelOutput {
    
}

class DefaultPointTrainingViewModel: PointTrainingViewModel {
    
    private let uid = Auth.auth().currentUser?.uid
    
    var error: Observable<String?> = Observable(nil)
    var profileStudent: Observable<ProfileStudent?> = Observable(nil)
    var listPoint: Observable<[PointTrainingYear]?> = Observable([])
    
    private let actions: PointTrainingActions?
    private let studentCode: String
    private let seachType: SearchType
    
    init(actions: PointTrainingActions?, studentCode: String, searchType: SearchType) {
        self.actions = actions
        self.studentCode = studentCode
        self.seachType = searchType
    }
    
    init(actions: PointTrainingActions?, studentCode: String) {
        self.actions = actions
        self.studentCode = studentCode
        self.seachType = .searchInfomationStudent
    }
    
    func viewDidLoad() {
        if UserDefaultsData.shared.posision == Position.manager.rawValue {
            self.getDataStudent(studentCode: self.studentCode) {
            }
            self.getListPointTraining(studentCode: self.studentCode) {
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
                        self.getListPointTraining(studentCode: self.studentCode) {
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
    
    private func getListPointTraining(studentCode: String, completion: @escaping () -> Void) {
        FSUserClient.shared.getDataPointTraining(studentCode: studentCode) { listPoint, error in
            guard let listPoint = listPoint,
                  error == nil else {
                self.error.value = error?.localizedDescription
                completion()
                return
            }
            print(listPoint)
            self.listPoint.value = listPoint
        }
        completion()
    }
}

