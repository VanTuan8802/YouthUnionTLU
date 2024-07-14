//
//  AddContentViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 16/6/24.
//

import UIKit

class AddContentViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var titleNew: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var viewAddTextCotent: UIView!
    @IBOutlet weak var textContent: UITextView!
    @IBOutlet weak var addTextContentBtn: UIButton!
    @IBOutlet weak var addImageBtn: UIButton!
    
    private var listContent: [ContentMock] = []
    private var viewModel: AddContentViewModel!
    private let placeholderText = "Nhập nội dung"
    private var new: PostModel!
    
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        createBtn.setTitle(R.stringLocalizable.buttonCreate(), for: .normal)
        addBtn.setTitle(R.stringLocalizable.postAddButton(), for: .normal)
        addTextContentBtn.setTitle(R.stringLocalizable.postText(), for: .normal)
        addImageBtn.setTitle(R.stringLocalizable.postImage(), for: .normal)
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
                self?.show(message: error, okTitle: R.stringLocalizable.buttonOk())
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
        let alertController = UIAlertController(
            title: "",
            message: R.stringLocalizable.messageCancel(),
            preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: R.stringLocalizable.buttonOk(), style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: R.stringLocalizable.buttonCancle(), style: .cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addTextContent(_ sender: Any) {
        viewAddTextCotent.isHidden = false
    }
    
    @IBAction func creatPostAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "",
            message: R.stringLocalizable.postCreate(),
            preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: R.stringLocalizable.buttonOk(), style: .default) { _ in
            self.viewModel.openHome(listContent: self.listContent)
            self.showToast(message: R.stringLocalizable.toastAddPostSuccess(),
                      duration: 3)
        }
        
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: R.stringLocalizable.buttonCancle(), style: .cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func addImageContent(_ sender: Any) {
        selectedIndexPath = nil
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addTextAction(_ sender: Any) {
        if let text = textContent.text, !text.isEmpty {
            let content = ContentMock(contentNumber: listContent.count + 1,
                                      textContent: text,
                                      contentType: .text)
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
        cell.fetchData(content: listContent[indexPath.row], at: indexPath)
        
        cell.imageCallback = { [weak self] imageView, indexPath in
            if let strongSelf = self {
                strongSelf.selectedIndexPath = indexPath
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = strongSelf
                imagePicker.sourceType = .photoLibrary
                strongSelf.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        return cell
    }
}

extension AddContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            if let indexPath = selectedIndexPath {
                listContent[indexPath.row].imageContent = selectedImage
                contentTableView.reloadRows(at: [indexPath], with: .automatic)
                contentTableView.reloadData()
            } else {
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


extension AddContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentTableView {
            if contentTableView.contentOffset.x != 0 {
                contentTableView.contentOffset.x = 0
            }
        }
    }
    
}
