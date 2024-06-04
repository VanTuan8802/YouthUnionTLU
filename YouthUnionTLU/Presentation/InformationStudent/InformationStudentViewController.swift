//
//  InformationStudentViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 19/4/24.
//

import UIKit
import Kingfisher

class InformationStudentViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var avatarStudent: UIImageView!
    @IBOutlet weak var dataStudentViiew: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var informationTableView: UITableView!
    
    private var profileStudent: ProfileStudent?
    
    private var dataProfile: [[Information]] = []
    
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
        dataStudentViiew.isHidden = false
        noDataView.isHidden = true
    }
    
    private func setUpTableView() {
        informationTableView.delegate = self
        informationTableView.dataSource = self
        
        informationTableView.register(UINib(nibName: InformationOneViewTableViewCell.className, bundle: nil), forCellReuseIdentifier: InformationOneViewTableViewCell.className)
        informationTableView.register(UINib(nibName: InformationTwoViewTableViewCell.className, bundle: nil), forCellReuseIdentifier: InformationTwoViewTableViewCell.className)
    }
    
    private func bindData(to viewMoldel:InformationStudentViewModel) {
        viewMoldel.profileStudent.observe(on: self) { profileStudentData in
            guard let profileStudentData = profileStudentData else {
                return
            }
            
            self.profileStudent = profileStudentData
            
            self.fetchData()
            self.avatarStudent.kf.setImage(with: URL(string: profileStudentData.avatarUrl ))
            self.informationTableView.reloadData()
            self.dataStudentViiew.isHidden = false
            self.noDataView.isHidden = true
        }
        
        viewMoldel.error.observe(on: self) {error in
            guard error != nil else {
                return
            }
            self.dataStudentViiew.isHidden = true
            self.noDataView.isHidden = false
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension InformationStudentViewController {
    private func fetchData() {
        
        dataProfile = [
            [Information(title: R.stringLocalizable.inforStudentName(),
                         content: profileStudent?.name ?? "")],
            [Information(title: R.stringLocalizable.inforStudentDateOfBirth(),
                         content: profileStudent?.date_Of_Birth ?? ""),
             Information(title:  R.stringLocalizable.inforStudentSex(),
                         content: profileStudent?.gender ?? "")],
            [Information(title: R.stringLocalizable.inforStudentPlaceOfBirth(),
                         content: profileStudent?.place_Of_Birth ?? "")],
            [Information(title: R.stringLocalizable.inforStudentNation(),
                         content: profileStudent?.nation ?? ""),
             Information(title: R.stringLocalizable.inforStudentReligion(),
                         content: profileStudent?.religion ?? "")],
            [Information(title: R.stringLocalizable.inforStudentPhoneNumber(),
                         content: profileStudent?.phoneNumber ?? "")],
            [Information(title: R.stringLocalizable.inforStudentCitizentId(),
                         content: profileStudent?.citizenId ?? "") ],
            [Information(title: R.stringLocalizable.inforStudentDateRange(),
                         content: profileStudent?.date_Of_Range ?? ""),
             Information(title: R.stringLocalizable.inforStudentAddressRange(),
                         content: profileStudent?.address_Of_Range ?? "")],
            [Information(title: R.stringLocalizable.inforStudentEmail(),
                         content: profileStudent?.email ?? "")],
            [Information(title: R.stringLocalizable.inforStudentStudentId(),
                         content: profileStudent?.student_Code ?? "")],
            [Information(title: R.stringLocalizable.inforStudentNation(),
                         content: profileStudent?.nation ?? ""),
             Information(title: R.stringLocalizable.inforStudentClass(),
                         content: profileStudent?.className ?? "")],
            [Information(title: R.stringLocalizable.inforStudentBatch(),
                         content: profileStudent?.batch ?? "")],
            [Information(title: R.stringLocalizable.inforStudentFaculty(),
                         content: profileStudent?.faculaty ?? "")],
            [Information(title: R.stringLocalizable.inforStudentBatch(),
                         content: profileStudent?.major ?? "") ],
            [Information(title: R.stringLocalizable.inforStudentYearOfAdmission(),
                         content: String(profileStudent?.year_Of_Admission ?? 0)),
             Information(title: R.stringLocalizable.inforStudentYearOfHighSchoolGraduation(),
                         content: String(profileStudent?.year_Of_HighSchool_Graduation ?? 0))],
            [Information(title: R.stringLocalizable.inforStudentAccountNumber(),
                         content: profileStudent?.bankName ?? ""),
             Information(title: R.stringLocalizable.inforStudentBankName(),
                         content: profileStudent?.bankName ?? "")],
        ]
        informationTableView.reloadData()
    }
}

extension InformationStudentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataProfile[indexPath.row]
        if data.count == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationOneViewTableViewCell.className, for: indexPath) as! InformationOneViewTableViewCell
            cell.bindData(infomation: data)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTwoViewTableViewCell.className, for: indexPath) as! InformationTwoViewTableViewCell
            cell.bindData(information: data)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension InformationStudentViewController: UIScrollViewDelegate {
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if (inforScrollView.contentOffset.x != 0) {
    //            inforScrollView.contentOffset.x = 0
    //        }
    //    }
}

