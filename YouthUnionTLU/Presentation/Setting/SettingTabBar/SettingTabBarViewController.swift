//
//  SettingTabBarViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import UIKit

class SettingTabBarViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var tabBarSetting: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var searchTabBarItem: UITabBarItem!
    @IBOutlet weak var settingTabBarItem: UITabBarItem!
    
    private var viewModel: SettingTabBarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarSetting?.delegate = self
        setUI()
    }
    
    class func create(with viewModel: SettingTabBarViewModel) -> SettingTabBarViewController {
        let vc = SettingTabBarViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func setUI() {
        tabBarSetting.selectedItem = settingTabBarItem
        
        homeTabBarItem.title = R.stringLocalizable.tabBarHome()
        searchTabBarItem.title = R.stringLocalizable.tabBarSearch()
        settingTabBarItem.title = R.stringLocalizable.tabBarSettings()
        
    }
}

extension SettingTabBarViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == homeTabBarItem {
            viewModel.openHomeTabBar()
        } else if item == searchTabBarItem {
            viewModel.openSearchTabBar()
        } else if item == settingTabBarItem {
            viewModel.viewDidLoad()
        }
    }
}
