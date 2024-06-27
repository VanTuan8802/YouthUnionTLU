//
//  PostViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PostActions {
    let showSearchInformation: () -> Void
}

protocol PostViewModelInput {
    func viewDidLoad()
    func openHome()
}

protocol PostViewModelOutput {
    var error: Observable<String?> {get}
    var listContent:  Observable<[ContentModel]?> {get}
}

protocol PostViewModel : PostViewModelInput, PostViewModelOutput {
    
}

class DefaultPostViewModel: PostViewModel {
    
    var error: Observable<String?> = Observable(nil)
    var listContent: Observable<[ContentModel]?> = Observable(nil)
    
    private var actions: PostActions?
    private var newId: String?
    private var postType: PostType?
    
    init(actions: PostActions? = nil, newId: String? = nil, postType: PostType) {
        self.actions = actions
        self.newId = newId
        self.postType = postType
    }
    
    func viewDidLoad() {
        getListContent {
            
        }
    }
    
    func openHome() {
        
    }
    
    private func getListContent( completion: @escaping() -> Void) {
        guard let newId = newId else {
            completion()
            return
        }
        
        FSPostClient.shared.getListContent(majorId: UserDefaultsData.shared.major,
                                           postType: postType ?? .new,
                                          postId: newId) { listContent, error in
            guard let listContent = listContent,
                  error == nil else {
                completion()
                return
            }
            
            self.listContent.value = listContent.sorted { $0.contentNumber < $1.contentNumber }
        }
        completion()
    }
}
