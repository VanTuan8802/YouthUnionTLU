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
    let showPointTraining:(String) -> Void
    let showSearch: () -> Void
}


protocol SearchInformationStudentViewModelInput {
    func viewDidLoad()
    func openInformationStudent(studentCode: String)
    func openPoinTraining(studentCode: String)
    func openSeach()
}

protocol SearchInformationStudentViewModelOutput {
    var error: Observable<String?> {get}
    var listMajor: Observable<[Major]?> {get}
    var searchType: Observable<SearchType> {get}
}

protocol SearchInformationStudentViewModel: SearchInformationStudentViewModelInput, SearchInformationStudentViewModelOutput {
    
}

class DefaultSearchInformationStudentModel: SearchInformationStudentViewModel {

    var error: Observable<String?> = Observable(nil)
    var listMajor: Observable<[Major]?> = Observable([])
    var searchType: Observable<SearchType> = Observable(SearchType.searchActivity)
    
    private let actions: SearchInformationStudentActions
    
    init(actions: SearchInformationStudentActions, searchType: SearchType) {
        self.actions = actions
        self.searchType.value = searchType
    }
}

extension DefaultSearchInformationStudentModel {
    func viewDidLoad() {
        print(searchType)
        getListMajor {
            
        }
    }
    
    func openInformationStudent(studentCode: String) {
        actions.showInformationStudent(studentCode)
    }
    
    func openPoinTraining(studentCode: String) {
        actions.showPointTraining(studentCode)
    }
    
    func openSeach() {
        actions.showSearch()
    }
    
    private func getListMajor(completion: @escaping () -> Void) {
        FSMajoyClient.shared.getListMajor { data, error in
            guard let data = data,
                  error == nil else {
                return
            }
            self.listMajor.value = data
        }
    }
}
