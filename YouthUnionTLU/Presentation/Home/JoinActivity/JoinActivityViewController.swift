//
//  JoinActivityViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 27/6/24.
//

import UIKit

class JoinActivityViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var studentCode: UITextField!
    @IBOutlet weak var classTxt: UITextField!
    @IBOutlet weak var nameStudentCode: UITextField!
    @IBOutlet weak var seatTxt: UITextField!
    @IBOutlet weak var viewImportPhoto: UIView!
    @IBOutlet weak var image: UIImageView!
    
    private var post: PostModel?
    private var viewModel: JoinActivityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bind(to: viewModel)
        setUI()
    }
    
    class func create(with viewModel: JoinActivityViewModel) -> JoinActivityViewController {
        let vc = JoinActivityViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func bind(to viewModel: JoinActivityViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error,
                           okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
        

        viewModel.postObs.observe(on: self) { [weak self] post in
            if let post = post {
                self?.post = post
                return
            }
        }
    }
    
    private func setUI() {
        studentCode.addPadding()
        classTxt.addPadding()
        nameStudentCode.addPadding()
        seatTxt.addPadding()
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectImageAction(_ sender: Any) {
        if PermissionManager.shared.checkPhotoLibraryPermission() == false {
            PermissionManager.shared.requestPhotoLibraryPermission { result in
                DispatchQueue.main.async {
                    if result == false {
                        let alertController = UIAlertController(title: "",
                                                                message: "Mở cài đặt và cấp quyền ảnh để tiếp tục",
                                                                preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: R.stringLocalizable.buttonOk(),
                                                     style: .default) { _ in
                            PermissionManager.shared.openSettingPermission()
                        }
                        
                        let cancelAction = UIAlertAction(title: R.stringLocalizable.buttonCancle(),
                                                         style: .cancel, handler: nil)
                        
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.presentImagePicker()
                    }
                }
            }
        } else {
            presentImagePicker()
        }
    }
    
    @IBAction func joinActivityAction(_ sender: Any) {
        let dispatchGroup = DispatchGroup()
        
        guard let image = image,
              let imageImg = image.image,
              let studentCode = studentCode.text,
              let post = post,
              let postId = post.id,
              let timeActivity = post.timeStartActivy,
              let address = post.address,
              let classStudent = classTxt.text,
              let nameStudent = nameStudentCode.text,
              let seat = seatTxt.text else {
            return
        }
        
        let path = "\(CollectionFireStore.activities.rawValue)/\(postId)/\(UserDefaultsData.shared.studentCode)"
        
        LoadingView.show()
        
        dispatchGroup.enter()
        FSStorageClient.shared.uploadImage(image: imageImg, path: path) { result in
            switch result {
            case .success(let downloadURL):
                let activity = JoinActivityModel(nameActivity: post.title,
                                                 timeActivity: timeActivity,
                                                 addressActivity: address,
                                                 studentCode: studentCode,
                                                 classStudent: classStudent,
                                                 nameStudent: nameStudent,
                                                 seatStudent: seat,
                                                 pathImage: downloadURL)
                dispatchGroup.enter()
                FSPostClient.shared.joinActivity(postId: postId, joinActivity: activity) { error in
                    if error != nil {
                        self.navigationController?.popViewController(animated: true)
                    }
                    dispatchGroup.leave()
                }
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            LoadingView.hide()
            self.viewModel.openPost()
        }
    }


}

extension JoinActivityViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewImportPhoto.isHidden = true
            image.isHidden = false
            image.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
