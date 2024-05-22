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
    
    private var viewModel: HomeTabBarViewModel!
    
    private var position: Position?
    
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
        
    }
    
    private func bind(to viewModel: HomeTabBarViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error,
                           okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
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

