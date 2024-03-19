//
//  LanguageViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 11/03/2024.
//

import UIKit

class LanguageViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var languageTableView: UITableView!
    
    private let items: [LanguageType] = [.vie, .eng, .lao, .fre, .cam]
    private var languageSelected: LanguageType!
    
    private var viewModel: LanguageViewModel!
    
    class func create(with viewModel: LanguageViewModel) -> LanguageViewController {
        let vc = LanguageViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSelected = UserDefaultsData.shared.language
   
        languageTitle.text = R.stringLocalizable.languageTitle()
        
        setupTableView()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func setupTableView() {
        languageTableView.delegate = self
        languageTableView.dataSource = self
        
        LanguageTableViewCell.register(languageTableView)
        
        languageTableView.isScrollEnabled = false
        languageTableView.separatorStyle = .none
        
        languageTableView.isPagingEnabled = true
        languageTableView.showsHorizontalScrollIndicator = true
    }
    
    private func bind(to viewModel: LanguageViewModel) {
    }
    
    @IBAction func checkAction(_ sender: Any) {
        UserDefaultsData.shared.language = languageSelected
        viewModel.openPermisstion()
    }
}

extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = LanguageTableViewCell.cell(for: tableView, at: indexPath) else {
            return UITableViewCell()
        }
        
        cell.bindData(language: items[indexPath.row], selected: items[indexPath.row] == languageSelected)
        return cell
    }
}

extension LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? LanguageTableViewCell {
            languageSelected = items[indexPath.row]
            print(languageSelected.name)
            cell.bindData(language: languageSelected, selected: items[indexPath.row] == languageSelected)
        }
        tableView.reloadData()
    }
}


