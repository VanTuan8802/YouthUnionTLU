//
//  SearchTabBarViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import UIKit

class SearchTabBarViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var tabBarSearch: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var searchTabBarItem: UITabBarItem!
    @IBOutlet weak var settingTabBarItem: UITabBarItem!
    @IBOutlet weak var viewSearchInformation: UIView!
    
    private var viewModel: SearchTabBarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarSearch?.delegate = self
        setUI()
    }
    
    private func setUI() {
        tabBarSearch.selectedItem = searchTabBarItem
        
        homeTabBarItem.title = R.stringLocalizable.tabBarHome()
        searchTabBarItem.title = R.stringLocalizable.tabBarSearch()
        settingTabBarItem.title = R.stringLocalizable.tabBarSettings()
        
        if  UserDefaultsData.shared.posision == Position.member.rawValue {
            viewSearchInformation.isHidden = true
        }
        
    }
    
    class func create(with viewModel: SearchTabBarViewModel) -> SearchTabBarViewController {
        let vc = SearchTabBarViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    @IBAction func openSearchActivity(_ sender: Any) {
        viewModel.openSearchActivity()
    }
    
    @IBAction func openSearchScore(_ sender: Any) {
        viewModel.openSearchScore()
    }
    
    @IBAction func searchInformationStudent(_ sender: Any) {
        viewModel.openSearchInformation()
    }
    

}

extension SearchTabBarViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == homeTabBarItem {
            viewModel.openHomeTabBar()
        } else if item == searchTabBarItem {
            viewModel.viewDidLoad()
        } else if item == settingTabBarItem {
            viewModel.openSettingTabBar()
        }
    }
}
