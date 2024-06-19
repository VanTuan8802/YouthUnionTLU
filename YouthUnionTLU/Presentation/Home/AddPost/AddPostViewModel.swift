//
//  AddPostViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 12/6/24.
//

import Foundation

struct AddPostViewActions {
    let showAddContent:(NewModelMock) -> Void
}

protocol AddPostViewModelInput {
    func viewDidload()
    func openAddContent(new: NewModelMock)
}

protocol AddPostViewModelOutPut {
    var error: Observable<String?> {get}
  
}

protocol AddPostViewModel: AddPostViewModelInput, AddPostViewModelOutPut {
    
}

class DefaultAddPostViewModel: AddPostViewModel {
    
    var error: Observable<String?> = Observable(nil)
    
    private var actions: AddPostViewActions
    
    
    init(actions: AddPostViewActions) {
        self.actions = actions
    }
    
    func viewDidload() {
        
    }
    
    func openAddContent(new: NewModelMock) {
        actions.showAddContent(new)
    }
    
}
