//
//  AddContentViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 16/6/24.
//

import Foundation

struct AddContentViewActions {
    let showHome: ([ContentMock]) -> Void
}

protocol AddContentViewModelInput {
    func viewDidload()
    func openHome(listContent: [ContentMock])
}

protocol AddContentViewModelOutput {
    var error: Observable<String?> {get}
    var titleNew: Observable<String?> {get}
    var postType: Observable<PostType> {get}
}

protocol AddContentViewModel: AddContentViewModelInput, AddContentViewModelOutput {
    
}

class DefaultAddContentViewModel: AddContentViewModel {
    
    var error: Observable<String?> = Observable(nil)
    var titleNew: Observable<String?> = Observable(nil)
    var postType: Observable<PostType> = Observable(.new)
    
    private var actions: AddContentViewActions
    var post: PostMock

    init(actions: AddContentViewActions, post: PostMock) {
        self.actions = actions
        self.post = post
    }
    
    func viewDidload() {
        titleNew.value = post.title
        postType.value = post.postType
    }
    
    func openHome(listContent: [ContentMock]) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        LoadingView.show()
        
        FSPostClient.shared.createPostStorage(post: post) { [weak self] path, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoadingView.hide()
                if let error = error {
                    print("Error creating new storage: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                
                guard let pathImage = path else {
                    print("Unknown error: Failed to get storage path")
                    dispatchGroup.leave()
                    return
                }
                
                let path = self.post.postType.rawValue + "_" + UserDefaultsData.shared.major
                FSPostClient.shared.createPost(path: path,
                                              post: self.post,
                                              pathImage: pathImage,
                                              listContent: listContent) { error in
                    if let error = error {
                        print("Error creating new: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
                
                if UserDefaultsData.shared.major == "All" {
                    FSMajoyClient.shared.getListMajorId { listMajorId, error in
                        guard let listMajorId = listMajorId, error == nil else {
                            print("Error getting list of major IDs: \(error?.localizedDescription ?? "Unknown error")")
                            dispatchGroup.leave()
                            return
                        }
                        
                        for majorId in listMajorId {
                            let path = self.postType.value.rawValue + "_" + majorId
                            FSPostClient.shared.createPost(path: path,
                                                          post: self.post,
                                                          pathImage: pathImage,
                                                          listContent: listContent) { error in
                                if let error = error {
                                    print("Error creating new: \(error.localizedDescription)")
                                }
                                
                            }
                        }
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.actions.showHome(listContent)
        }
    }
    
}
