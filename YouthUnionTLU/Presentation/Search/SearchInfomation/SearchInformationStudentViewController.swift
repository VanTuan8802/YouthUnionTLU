//
//  SearchInformationStudentViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 23/5/24.
//

import UIKit

class SearchInformationStudentViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var majorLb: UILabel!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var batchLb: UILabel!
    @IBOutlet weak var batchTxt: UITextField!
    @IBOutlet weak var classLb: UILabel!
    @IBOutlet weak var classTxt: UITextField!
    @IBOutlet weak var majoyTableView: UITableView!
    @IBOutlet weak var studentCodeLb: UILabel!
    @IBOutlet weak var studentCodeTxt: UITextField!
    @IBOutlet weak var showHideBtn: UIButton!
    @IBOutlet weak var showDataStudent: UIButton!
    
    private var viewModel : SearchInformationStudentViewModel!
    private var listMajor: [Major] = []
    private var searchType: SearchType = .searchInfomationStudent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setUI()
        setUpTableView()
        bindData(to: viewModel)
        majoyTableView.isHidden = true
    }
    
    class func create(with viewModel: SearchInformationStudentViewModel) -> SearchInformationStudentViewController {
        let vc = SearchInformationStudentViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func setUI() {
        majorTxt.addPadding()
        batchTxt.addPadding()
        classTxt.addPadding()
        studentCodeTxt.addPadding()
        
        searchTitle.text = R.stringLocalizable.searchSearchTitle()
        majorLb.text = R.stringLocalizable.inforStudentMajor()
        batchLb.text = R.stringLocalizable.inforStudentBatch()
        classLb.text = R.stringLocalizable.inforStudentClass()
        studentCodeLb.text = R.stringLocalizable.inforStudentStudentId()
        showDataStudent.setTitle(R.stringLocalizable.tabBarSearch(), for: .normal)
    }
    
    private func setUpTableView() {
        majoyTableView.dataSource = self
        majoyTableView.delegate = self
        
        majoyTableView.register(UINib(nibName: MajorTableViewCell.className, bundle: nil), forCellReuseIdentifier:  MajorTableViewCell.className)
    }
    
    private func bindData(to viewModel: SearchInformationStudentViewModel) {
        viewModel.listMajor.observe(on: self) { listMajorData in
            guard let listMajorData = listMajorData else {
                return
            }
            self.listMajor = listMajorData
            self.majoyTableView.reloadData()
        }
        
        viewModel.searchType.observe(on: self) { searchType in
            self.searchType = searchType
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showTableView(_ sender: Any) {
        majoyTableView.isHidden = false
        majoyTableView.reloadData()
    }
    
    @IBAction func showInformation(_ sender: Any) {
        if searchType == .searchActivity {
            viewModel.openJoinActivity(studentCode: studentCodeTxt.text ?? "")
        } else {
            if searchType == .searchPointTraining {
                viewModel.openPoinTraining(studentCode: studentCodeTxt.text ?? "")
            } else {
                viewModel.openInformationStudent(studentCode: studentCodeTxt.text ?? "")
            }
        }
    }
}

extension SearchInformationStudentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMajor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MajorTableViewCell.className, for: indexPath) as! MajorTableViewCell
        cell.nameMajorLb.text = listMajor[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        majorTxt.text = listMajor[indexPath.row].name
        majoyTableView.isHidden = true
    }
}
