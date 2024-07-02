//
//  JoinActivityViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 27/6/24.
//

import Foundation

struct JoinActivityViewActions {
    let showPost:() -> Void
}

protocol JoinActivityViewModelInput {
    func viewDidLoad()
    func openPost()
}

protocol JoinActivityViewModelOutput {
    var error: Observable<String?> {get}
    var postIdValue: Observable<String?> {get}
}

protocol JoinActivityViewModel: JoinActivityViewModelInput, JoinActivityViewModelOutput {
    
}

class DefaultJoinActivityViewModel: JoinActivityViewModel {
    var postIdValue: Observable<String?> =  Observable(nil)
    var error: Observable<String?> = Observable(nil)
    
    private var actions: JoinActivityViewActions
    private var postId: String?
    
    init(actions: JoinActivityViewActions, postId: String? = nil) {
        self.actions = actions
        self.postId = postId
    }
    
    func viewDidLoad() {
        postIdValue.value = postId
    }
    
    func openPost() {
        actions.showPost()
    }
    
}

