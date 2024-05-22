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
}

protocol InformationStudentViewModel: InformationStudentViewModelInput, InformationStudentViewModelInput {
    
}

class DefaultInformationStudentViewModel: InformationStudentViewModel {
    
    private let uid = Auth.auth().currentUser?.uid
    
    var error: Observable<String?> = Observable(nil)
    
    private let actions: InformationStudentActions?
    
    init(actions: InformationStudentActions?) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        getDataStudent()
    }
    
    func openSearchInformation() {
        
    }
    
    func openSetting() {
        
    }
    
    func getDataStudent() {
        var studentCode: String = ""
        
        if UserDefaultsData.shared.posision == Position.member.rawValue {
            studentCode = UserDefaultsData.shared.studentCode
        }
        
        FSUserClient.shared.getDataUser(studentCode: studentCode) { user, error in
            print(user)
        }
    }
}
