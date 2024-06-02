//
//  SearchInformationStudentViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 23/5/24.
//

import Foundation
import FirebaseAuth

struct SearchInformationStudentActions {
    let showInformationStudent: (String) -> Void
    let showSearch: () -> Void
}


protocol SearchInformationStudentViewModelInput {
    func viewDidLoad()
    func openInformationStudent(studentCode: String)
    func openSeach()
}

protocol SearchInformationStudentViewModelOutput {
    var error: Observable<String?> {get}
    var listMajor: Observable<[Major]?> {get}
}

protocol SearchInformationStudentViewModel: SearchInformationStudentViewModelInput, SearchInformationStudentViewModelOutput {
    
}

class DefaultSearchInformationStudentModel: SearchInformationStudentViewModel {

    var error: Observable<String?> = Observable(nil)
    var listMajor: Observable<[Major]?> = Observable([])
    
    private let actions: SearchInformationStudentActions
    
    init(actions: SearchInformationStudentActions) {
        self.actions = actions
    }
}

extension DefaultSearchInformationStudentModel {
    func viewDidLoad() {
        getListMajor {
            
        }
    }
    
    func openInformationStudent(studentCode: String) {
        actions.showInformationStudent(studentCode)
    }
    
    func openSeach() {
        actions.showSearch()
    }
    
    private func getListMajor(completion: @escaping () -> Void) {
        FSMajoyClient.shared.getListMajoy { data, error in
            guard let data = data,
                  error == nil else {
                return
            }
            self.listMajor.value = data
        }
    }
}
