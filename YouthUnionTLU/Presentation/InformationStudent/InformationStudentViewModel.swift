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
    var persionalInformation: Observable<PersionalInformation?> {get}
    var studentInformation: Observable<StudentInformation?> {get}
}

protocol InformationStudentViewModel: InformationStudentViewModelInput, InformationStudentViewModelOutput {
    
}

class DefaultInformationStudentViewModel: InformationStudentViewModel {
    private let uid = Auth.auth().currentUser?.uid
    
    
    var error: Observable<String?> = Observable(nil)
    var persionalInformation: Observable<PersionalInformation?> = Observable(nil)
    var studentInformation: Observable<StudentInformation?> = Observable(nil)
    
    private let actions: InformationStudentActions?
    private let studentCode: String
    
    init(actions: InformationStudentActions?, studentCode: String) {
        self.actions = actions
        self.studentCode = studentCode
    }
    
    func viewDidLoad() {
        getDataStudent(studentCode: "2051062363") {
           
        }
    }

    func openSearchInformation() {
        
    }

    func openSetting() {
        
    }

    private func getDataStudent(studentCode: String, completion: @escaping () -> Void) {
        
        let group = DispatchGroup()
        
        group.enter()
        FSUserClient.shared.getDataProfile(studentCode: studentCode) { personalInformationData, error in
            defer {
                group.leave()
            }
            
            if let error = error {
                print("Error fetching personal information: \(error.localizedDescription)")
                return
            }
            
            guard let personalInformationData = personalInformationData else {
                print("Personal information data is nil")
                return
            }
            
            self.persionalInformation.value = personalInformationData
        }
        
        group.enter()
        FSUserClient.shared.getDataStudent(studentCode: studentCode) { studentInformationData, error in
            defer {
                group.leave()
            }
            
            if let error = error {
                print("Error fetching student information: \(error.localizedDescription)")
                return
            }
            
            guard let studentInformationData = studentInformationData else {
                print("Student information data is nil")
                return
            }
            
            self.studentInformation.value = studentInformationData
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }

}
