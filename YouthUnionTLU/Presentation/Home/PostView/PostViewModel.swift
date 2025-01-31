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
    let showJoinActivity: (PostModel) -> Void
}

protocol PostViewModelInput {
    func viewDidLoad()
    func openHome()
    func openJoinActivity(post: PostModel)
}

protocol PostViewModelOutput {
    var error: Observable<String?> {get}
    var postObs: Observable<PostModel?> {get}
    var listContent:  Observable<[ContentModel]?> {get}
}

protocol PostViewModel : PostViewModelInput, PostViewModelOutput {
    
}

class DefaultPostViewModel: PostViewModel {
    
    var error: Observable<String?> = Observable(nil)
    var listContent: Observable<[ContentModel]?> = Observable(nil)
    var postObs: Observable<PostModel?> = Observable(nil)
    
    private var actions: PostActions?
    private var post: PostModel?
    
    init( actions: PostActions? = nil, post: PostModel? = nil) {
        self.actions = actions
        self.post = post
    }
    
    func viewDidLoad() {
        getListContent {
            
        }
        
        postObs.value = post
    }
    
    func openHome() {
        
    }
    
    func openJoinActivity(post: PostModel) {
        actions?.showJoinActivity(post)
    }
    
    private func getListContent(completion: @escaping() -> Void) {
        guard let post = post,
              let postId = post.id else {
            completion()
            return
        }

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        LoadingView.show()

        FSPostClient.shared.getListContent(majorId: UserDefaultsData.shared.major, post: post) { listContent, error in
            defer {
                dispatchGroup.leave()
            }
            
            guard let listContent = listContent,
                  error == nil else {
                completion()
                return
            }

            self.listContent.value = listContent.sorted { $0.contentNumber < $1.contentNumber }
        }

        dispatchGroup.notify(queue: .main) {
            LoadingView.hide()
            completion()
        }
    }

}
