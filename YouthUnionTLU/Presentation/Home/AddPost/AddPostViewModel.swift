//
//  AddPostViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 12/6/24.
//

import Foundation

struct AddPostViewActions {
    let showAddContent:(PostMock) -> Void
}

protocol AddPostViewModelInput {
    func viewDidload()
    func openAddContent(post: PostMock)
}

protocol AddPostViewModelOutPut {
    var error: Observable<String?> {get}
    var postTypeValue: Observable<PostType?> {get}
}

protocol AddPostViewModel: AddPostViewModelInput, AddPostViewModelOutPut {
    
}

class DefaultAddPostViewModel: AddPostViewModel {
    
    var postTypeValue: Observable<PostType?> = Observable(nil)
    var error: Observable<String?> = Observable(nil)
    
    private var actions: AddPostViewActions
    private var postType: PostType
    
    init(actions: AddPostViewActions, postType: PostType) {
        self.actions = actions
        self.postType = postType
    }
    
    func viewDidload() {
        postTypeValue.value = postType
    }
    
    func openAddContent(post: PostMock) {
        actions.showAddContent(post)
    }
    
}
