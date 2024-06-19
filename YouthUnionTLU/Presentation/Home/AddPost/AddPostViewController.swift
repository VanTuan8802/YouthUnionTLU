//
//  AddPostViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 12/6/24.
//

import UIKit
import Photos
import FirebaseFirestoreInternal

class AddPostViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var viewImportPhoto: UIView!
    @IBOutlet weak var imagePost: UIImageView!
    
    private var viewModel: AddPostViewModel!
    private let placeholderText = "Nhập tiêu đề"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextView.delegate = self
        
        setupPlaceholder()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupPlaceholder() {
        if titleTextView.text.isEmpty {
            titleTextView.text = placeholderText
            titleTextView.textColor = .lightGray
        }
    }
    
    class func create(with viewModel: AddPostViewModel) -> AddPostViewController {
        let vc = AddPostViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        if PermissionManager.shared.checkPhotoLibraryPermission() == false {
            PermissionManager.shared.requestPhotoLibraryPermission { result in
                DispatchQueue.main.async {
                    if result == false {
                        let alertController = UIAlertController(title: "",
                                                                message: "Mở cài đặt và cấp quyền ảnh để tiếp tục",
                                                                preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            PermissionManager.shared.openSettingPermission()
                        }
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        
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
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard let title = titleTextView.text,
              title != placeholderText ,
              let image = imagePost.image else {
            return
        }
        
        let newModel = NewModelMock(id: UUID().uuidString,
                                    imageNew: image,
                                    title: title,
                                    timeCreate: Timestamp(date: Date()))
        self.viewModel.openAddContent(new: newModel)
        
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewImportPhoto.isHidden = true
            imagePost.isHidden = false
            imagePost.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}
