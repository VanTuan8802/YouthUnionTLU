//
//  HomeTabBarViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import UIKit

class HomeTabBarViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var searchTabBarItem: UITabBarItem!
    @IBOutlet weak var settingTabBarItem: UITabBarItem!
    @IBOutlet weak var newsTableView: UITableView!
    
    private var viewModel: HomeTabBarViewModel!
    
    private var position: Position?
    
    private var news: [NewModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bind(to: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar?.delegate = self
        setUI()
        viewModel.viewDidLoad()
    }
    
    class func create(with viewModel: HomeTabBarViewModel) -> HomeTabBarViewController {
        let vc = HomeTabBarViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    private func setUI() {
        tabBar.selectedItem = homeTabBarItem
        homeTabBarItem.title = R.stringLocalizable.tabBarHome()
        searchTabBarItem.title = R.stringLocalizable.tabBarSearch()
        settingTabBarItem.title = R.stringLocalizable.tabBarSettings()
        
        setUpTableView()
        
    }
    
    private func bind(to viewModel: HomeTabBarViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error,
                           okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
        
        viewModel.listNew.observe(on: self) { listModel in
            guard let lisModel = listModel else {
                return
            }
            
            self.news = lisModel
            self.newsTableView.reloadData()
        }
    }
    
    private func setUpTableView() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.register(UINib(nibName: NewTableViewCell.className, bundle: nil) , forCellReuseIdentifier: NewTableViewCell.className)
    }
}

extension HomeTabBarViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == homeTabBarItem {
            viewModel.viewDidLoad()
        } else if item == searchTabBarItem {
            viewModel.openSearchTabBar()
        } else if item == settingTabBarItem {
            viewModel.openSettingTabBar()
        }
    }
}

extension HomeTabBarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTableViewCell.className, for: indexPath) as! NewTableViewCell
        cell.fetchData(new: news[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openPost(newId: news[indexPath.row].id ?? "")
    }
}
