//
//  SearchJoinActivityViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 3/7/24.
//

import UIKit

class SearchJoinActivityViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var joinActivityLb: UILabel!
    @IBOutlet weak var joinActivityTableView: UITableView!
    
    private var viewModel: SearchJoinActivityViewModel!
    
    private var listJoinActivity: [JoinActivityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
        setUI()
        bindData(to: viewModel)
        setUpTableView()
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
            self.joinActivityTableView.reloadData()
        }

        
        viewMoldel.error.observe(on: self) {error in
            guard error != nil else {
                return
            }
            
        }
    }
    
    private func setUI() {
        joinActivityLb.text = R.stringLocalizable.searchActivity()
    }
    
    private func setUpTableView() {
        joinActivityTableView.delegate = self
        joinActivityTableView.dataSource = self
        
        joinActivityTableView.rowHeight = UITableView.automaticDimension
        
        joinActivityTableView.register(UINib(nibName: JoinActivityTableViewCell.className, bundle: nil ), forCellReuseIdentifier: JoinActivityTableViewCell.className)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SearchJoinActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listJoinActivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let joinActivity = listJoinActivity[indexPath.row]
        print(joinActivity)
        let cell = tableView.dequeueReusableCell(withIdentifier: JoinActivityTableViewCell.className, for: indexPath) as! JoinActivityTableViewCell
        cell.fetchData(joinActivity: joinActivity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
}
