//
//  SearchJoinActivityViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 3/7/24.
//

import UIKit

class SearchJoinActivityViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var joinActivityTableView: UITableView!
    
    private var viewModel: SearchJoinActivityViewModel!
    
    private var listJoinActivity: [JoinActivityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
        bindData(to: viewModel)
    }
    
    class func create(with viewModel: SearchJoinActivityViewModel) -> SearchJoinActivityViewController {
        let vc = SearchJoinActivityViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func bindData(to viewMoldel:SearchJoinActivityViewModel) {
        viewMoldel.listJoinActivity.observe(on: self) { listJoinActivity in
            guard let listJoinActivity = listJoinActivity else {
                return
            }
            
            self.listJoinActivity = listJoinActivity
            
            print(listJoinActivity)
        }

        
        viewMoldel.error.observe(on: self) {error in
            guard error != nil else {
                return
            }
            
        }
    }
    
}

extension SearchJoinActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listJoinActivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let joinActivity = listJoinActivity[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: JoinActivityTableViewCell.className, for: indexPath) as! JoinActivityTableViewCell
        return cell
    }
    
    
}
