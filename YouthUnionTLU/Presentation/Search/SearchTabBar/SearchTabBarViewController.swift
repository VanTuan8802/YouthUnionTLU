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
    @IBOutlet weak var searchActivityLb: UILabel!
    @IBOutlet weak var searchPointTraningLb: UILabel!
    @IBOutlet weak var searchInfomationLb: UILabel!
    
    private var viewModel: SearchTabBarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
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
        
        searchActivityLb.text = R.stringLocalizable.searchActivity()
        searchPointTraningLb.text = R.stringLocalizable.searchPointTraing()
        searchInfomationLb.text = R.stringLocalizable.searchInfo()
        
    }
    
    class func create(with viewModel: SearchTabBarViewModel) -> SearchTabBarViewController {
        let vc = SearchTabBarViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    @IBAction func openSearchActivity(_ sender: Any) {
        if UserDefaultsData.shared.posision == Position.member.rawValue {
            viewModel.openMyJoinActivity()
        } else {
            viewModel.openSearchInformation(searchType: .searchActivity)
        }
    }
    
    @IBAction func openSearchScore(_ sender: Any) {
        if UserDefaultsData.shared.posision == Position.member.rawValue {
            viewModel.openMyScore()
        } else {
            viewModel.openSearchInformation(searchType: .searchPointTraining)
        }
    }
    
    @IBAction func searchInformationStudent(_ sender: Any) {
        viewModel.openSearchInformation(searchType: .searchInfomationStudent)
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
