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
    var postObs: Observable<PostModel?> {get}
}

protocol JoinActivityViewModel: JoinActivityViewModelInput, JoinActivityViewModelOutput {
    
}

class DefaultJoinActivityViewModel: JoinActivityViewModel {

    var error: Observable<String?> = Observable(nil)
    var postObs: Observable<PostModel?> = Observable(nil)
    
    private var actions: JoinActivityViewActions
    private var post: PostModel?

    init(actions: JoinActivityViewActions, post: PostModel) {
        self.actions = actions
        self.post = post
    }
    
    func viewDidLoad() {
        postObs.value = post
    }
    
    func openPost() {
        actions.showPost()
    }
    
}

