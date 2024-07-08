//
//  AddContentViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 16/6/24.
//

import UIKit

class AddContentViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var titleNew: UILabel!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var viewAddTextCotent: UIView!
    @IBOutlet weak var textContent: UITextView!
    
    private var listContent: [ContentMock] = []
    private var viewModel: AddContentViewModel!
    private let placeholderText = "Nhập nội dung"
    private var new: PostModel!
    
    override func viewDidLoad() {
        viewModel.viewDidload()
        bindData(to: viewModel)
        textContent.delegate = self
        setUI()
        setUpTableView()
    }
    
    class func create(with viewModel: AddContentViewModel) -> AddContentViewController {
        let vc = AddContentViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func setUI() {
        if textContent.text.isEmpty {
            textContent.text = placeholderText
            textContent.textColor = .lightGray
        }
        
        viewAddTextCotent.isHidden = true
    }
    
    private func setUpTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        contentTableView.rowHeight = UITableView.automaticDimension
        
        contentTableView.register(UINib(nibName: AddContentTableViewCell.className, bundle: nil), forCellReuseIdentifier: AddContentTableViewCell.className)
    }
    
    
    
    private func bindData(to viewModel: AddContentViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error,
                           okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
        
        viewModel.titleNew.observe(on: self) { titleNewText in
            guard let titleNewText = titleNewText else {
                return
            }
            self.titleNew.text = titleNewText
        }
    }
    
    private func scrollToBottom() {
        let numberOfSections = contentTableView.numberOfSections
        let numberOfRows = contentTableView.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: numberOfSections-1)
            contentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Thoát", 
                                                message: "Bạn có muốn thoát không?",
                                                preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Có", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Không", style: .cancel) { _ in
          
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func addTextContent(_ sender: Any) {
        viewAddTextCotent.isHidden = false
    }
    
    @IBAction func creatPostAction(_ sender: Any) {
        viewModel.openHome(listContent: listContent)
    }
    
    @IBAction func addImageContent(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addTextAction(_ sender: Any) {
        if textContent.text != nil && textContent.text != "" {
            let content = ContentMock(contentNumber: listContent.count + 1,
                                           textContent: textContent.text,
                                           contentType: .text
            )
            listContent.append(content)
            contentTableView.reloadData()
            DispatchQueue.main.async {
                self.scrollToBottom()
            }
        }
        textContent.text = nil
        viewAddTextCotent.isHidden = true
    }
}

extension AddContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddContentTableViewCell.className, for: indexPath) as! AddContentTableViewCell
        cell.fetchData(content: listContent[indexPath.row])
        return cell
    }
}

extension AddContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentTableView {
            if contentTableView.contentOffset.x != 0 {
                contentTableView.contentOffset.x = 0
            }
        }
    }
}

extension AddContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let content = ContentMock(
                contentNumber: listContent.count + 1,
                imageContent: selectedImage,
                contentType: .image
            )
            listContent.append(content)
            contentTableView.reloadData()
            DispatchQueue.main.async {
                self.scrollToBottom()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddContentViewController:  UITextViewDelegate {
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

