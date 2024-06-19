//
//  AddContentViewModel.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 16/6/24.
//

import Foundation

struct AddContentViewActions {
    let showHome: ([ContentModelMock]) -> Void
}

protocol AddContentViewModelInput {
    func viewDidload()
    func openHome(listContent: [ContentModelMock])
}

protocol AddContentViewModelOutput {
    var error: Observable<String?> {get}
    var titleNew: Observable<String?> {get}
}

protocol AddContentViewModel: AddContentViewModelInput, AddContentViewModelOutput {
    
}

class DefaultAddContentViewModel: AddContentViewModel {
    
    var error: Observable<String?> = Observable(nil)
    var titleNew: Observable<String?> = Observable(nil)
    
    private var actions: AddContentViewActions
    
    var new: NewModelMock
    
    init(actions: AddContentViewActions,new: NewModelMock) {
        self.actions = actions
        self.new = new
    }
    
    func viewDidload() {
        titleNew.value = new.title
    }
    
    func openHome(listContent: [ContentModelMock]) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        LoadingView.show()
        
        FSNewClient.shared.createNewStorage(new: new) { [weak self] path, error in
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
                
                let path = CollectionFireStore.new.rawValue + "_" + UserDefaultsData.shared.major
                FSNewClient.shared.createNew(path: path, new: self.new, pathImage: pathImage, listContent: listContent) { error in
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
                            let path = CollectionFireStore.new.rawValue + "_" + majorId
                            FSNewClient.shared.createNew(path: path, new: self.new, pathImage: pathImage, listContent: listContent) { error in
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
