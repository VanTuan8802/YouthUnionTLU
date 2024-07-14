//
//  SettingTabBarViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import UIKit

class SettingTabBarViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var infoUserBtn: UIButton!
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var infoUserLb: UILabel!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var languageLb: UILabel!
    @IBOutlet weak var sharedLb: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var rateLb: UILabel!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var polictyBtn: UIButton!
    @IBOutlet weak var policyLb: UILabel!
    @IBOutlet weak var changePassBtn: UIButton!
    @IBOutlet weak var changePasswordLb: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var logoutLb: UILabel!
    
    @IBOutlet weak var tabBarSetting: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var searchTabBarItem: UITabBarItem!
    @IBOutlet weak var settingTabBarItem: UITabBarItem!
    
    private var viewModel: SettingTabBarViewModel!
    
    private let position = UserDefaultsData.shared.posision
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
        
        bind(to: viewModel)
    }
    
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
        
        infoUserBtn.isEnabled = (position == Position.member.rawValue)
        
        settingTitle.text = R.stringLocalizable.tabBarSettings()
        infoUserLb.text = R.stringLocalizable.settingInfo()
        languageLb.text = R.stringLocalizable.languageTitle()
        sharedLb.text = R.stringLocalizable.settingShared()
        rateLb.text = R.stringLocalizable.settingRate()
        policyLb.text = R.stringLocalizable.settingPolicy()
        changePasswordLb.text = R.stringLocalizable.settingChangePassword()
        logoutLb.text = R.stringLocalizable.settingLogout()

    }
    
    private func bind(to viewModel: SettingTabBarViewModel) {
        viewModel.error.observe(on: self) { [weak self] error in
            if let error = error {
                self?.show(message: error,
                           okTitle: R.stringLocalizable.buttonOk())
                return
            }
        }
    }
    
    @IBAction func showInformationAction(_ sender: Any) {
        viewModel.openInformation(studentCode: UserDefaultsData.shared.studentCode)
    }
    
    @IBAction func chageLanguageAction(_ sender: Any) {
        viewModel.openLanguage()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if let url = URL(string: Constants.Key.appStoreLink) {
                   let objectsToShare: [Any] = [url]
                   let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                   self.present(activityVC, animated: true, completion: nil)
               }
    }
    
    @IBAction func rateAction(_ sender: Any) {

    }
    
    @IBAction func policyAction(_ sender: Any) {
        
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        viewModel.openChangePassword()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        viewModel.openLogOut()
    }
}

extension SettingTabBarViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == homeTabBarItem {
            viewModel.openHomeTabBar()
        } else if item == searchTabBarItem {
            viewModel.openSearchTabBar()
        } else {
            viewModel.viewDidLoad()
        }
    }
}
