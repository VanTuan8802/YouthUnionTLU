//
//  PostViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import UIKit

class PostViewController: UIViewController , StoryboardInstantiable{

    
    @IBOutlet weak var contentsTableView: UITableView!
    
    private var listContent: [ContentModel] = []
    private var viewModel: PostViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setUpTableView()
        bind(to: viewModel)
    }
    
    class func create(with viewModel: PostViewModel) -> PostViewController {
        let vc = PostViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func setUpTableView() {
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        
        contentsTableView.rowHeight = UITableView.automaticDimension
        
        contentsTableView.register(UINib(nibName: ContentTableViewCell.className, bundle: nil), forCellReuseIdentifier: ContentTableViewCell.className)
    }
    
    private func bind(to viewModel: PostViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error,
                           okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
        
        viewModel.listContent.observe(on: self) { listContent in
            guard let listContent = listContent else {
                return
            }
            
            self.listContent = listContent
            self.contentsTableView.reloadData()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.className, for: indexPath) as! ContentTableViewCell
        cell.fetchData(content: listContent[indexPath.row])
        return cell
    }
}
