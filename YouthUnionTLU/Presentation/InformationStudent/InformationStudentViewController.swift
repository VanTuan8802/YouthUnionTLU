//
//  InformationStudentViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 19/4/24.
//

import UIKit
import King

class InformationStudentViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var avatarStudent: UIImageView!
    @IBOutlet weak var informationTableView: UITableView!
    
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var birthdayLb: UILabel!
    @IBOutlet weak var birthDayTxt: UITextField!
    @IBOutlet weak var sexLb: UILabel!
    @IBOutlet weak var sexTxt: UITextField!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var nationLb: UILabel!
    @IBOutlet weak var nationTxt: UITextField!
    @IBOutlet weak var religionLb: UILabel!
    @IBOutlet weak var religionTxt: UITextField!
    @IBOutlet weak var citizenIdLb: UILabel!
    @IBOutlet weak var citizenIdTxt: UITextField!
    @IBOutlet weak var dateRangeLb: UILabel!
    @IBOutlet weak var dateRangeTxt: UITextField!
    @IBOutlet weak var addressRangeLb: UILabel!
    @IBOutlet weak var addressRangeTxt: UITextField!
    @IBOutlet weak var inforStudentLb: UILabel!
    @IBOutlet weak var studentIdLb: UILabel!
    @IBOutlet weak var studentIdTxt: UITextField!
    @IBOutlet weak var classLb: UILabel!
    @IBOutlet weak var classTxt: UITextField!
    @IBOutlet weak var batchLb: UILabel!
    @IBOutlet weak var batchTxt: UITextField!
    @IBOutlet weak var facultyLb: UILabel!
    @IBOutlet weak var facultyTxt: UITextField!
    @IBOutlet weak var majorLb: UILabel!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var yearOfAdmissionLb: UILabel!
    @IBOutlet weak var yearOfAdmissionTxt: UITextField!
    @IBOutlet weak var yearOfHighSchoolGraduationLb: UILabel!
    @IBOutlet weak var yearOfHighSchoolGraduationTxt: UITextField!
    @IBOutlet weak var accountNumberLb: UILabel!
    @IBOutlet weak var accountNumberTxt: UITextField!
    @IBOutlet weak var bankNameLb: UILabel!
    @IBOutlet weak var bankNameTxt: UITextField!
    
    private var persionInformation: PersionalInformation?
    private var studentInformation: StudentInformation?
    
    private var dataProfile: [[Information]] = []
    private var dataStudent: [[Information]] = []
    
    private var viewModel: InformationStudentViewModel!
    
    class func create(with viewModel: InformationStudentViewModel) -> InformationStudentViewController {
        let vc = InformationStudentViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
        bindData(to: viewModel)
        setUpTableView()
        setUI()
    }
    
    private func setUI() {
//        nameLb.text = R.stringLocalizable.inforStudentName()
//        nameTxt.addPadding()
//        birthdayLb.text = R.stringLocalizable.inforStudentDateOfBirth()
//        birthDayTxt.addPadding()
//        sexLb.text = R.stringLocalizable.inforStudentSex()
//        sexTxt.addPadding()
//        addressLb.text = R.stringLocalizable.inforStudentPlaceOfBirth()
//        addressTxt.addPadding()
//        nationLb.text = R.stringLocalizable.inforStudentNation()
//        nationTxt.addPadding()
//        religionLb.text = R.stringLocalizable.inforStudentReligion()
//        religionTxt.addPadding()
//        citizenIdLb.text = R.stringLocalizable.inforStudentCitizentId()
//        citizenIdTxt.addPadding()
//        dateRangeLb.text = R.stringLocalizable.inforStudentDateRange()
//        dateRangeTxt.addPadding()
//        addressRangeLb.text = R.stringLocalizable.inforStudentAddressRange()
//        addressRangeTxt.addPadding()
        
    }
    
    private func setUpTableView() {
        informationTableView.delegate = self
        informationTableView.dataSource = self
        
        informationTableView.register(UINib(nibName: InformationOneViewTableViewCell.className, bundle: nil), forCellReuseIdentifier: InformationOneViewTableViewCell.className)
        informationTableView.register(UINib(nibName: InformationTwoViewTableViewCell.className, bundle: nil), forCellReuseIdentifier: InformationTwoViewTableViewCell.className)
    }
    
    private func bindData(to viewMoldel:InformationStudentViewModel) {
        viewMoldel.persionalInformation.observe(on: self) { persionalInformationData in
            guard let persionalInformationData = persionalInformationData else {
                return
            }
            self.persionInformation = persionalInformationData
        }
        
        viewMoldel.studentInformation.observe(on: self) { studentInformationData in
            guard let studentInformationData = studentInformationData else {
                return
            }
            self.studentInformation = studentInformationData
        }
    }
    
}

extension InformationStudentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProfile.count
        } else {
            return dataStudent.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension InformationStudentViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (inforScrollView.contentOffset.x != 0) {
//            inforScrollView.contentOffset.x = 0
//        }
//    }
}

extension InformationStudentViewController {
    private func fetchData() {
        avatarStudent.k
        dataProfile = [
            Information(title: <#T##String#>, content: <#T##String#>)
        ]
    }
}


