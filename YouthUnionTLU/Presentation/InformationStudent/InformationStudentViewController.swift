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
    @IBOutlet weak var informationTableView: UITableView!
    
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
            self.avatarStudent.kf.setImage(with: URL(string: "https://scontent.fhan2-3.fna.fbcdn.net/v/t39.30808-1/440865108_834321255210574_4695038794190883184_n.jpg?stp=dst-jpg_p480x480&_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeFc0Pcmgyr0PVi436O_fVcg8BKwH946bDLwErAf3jpsMhKRZpcop4F0-G5Z8O0m_GzWQiVeaSNEkiBKCqtc_hBp&_nc_ohc=lxIv9OzEuucQ7kNvgGtYUnD&_nc_ht=scontent.fhan2-3.fna&oh=00_AYBDJlMF9MjkUtO7U3usS4Lurc6dCx2TAW8fUpPlm-dwUw&oe=6653D8A7"))
            
            viewMoldel.studentInformation.observe(on: self) { studentInformationData in
                guard let studentInformationData = studentInformationData else {
                    return
                }
                self.studentInformation = studentInformationData
                self.fetchData()
            }
        }
    }
}

extension InformationStudentViewController {
    private func fetchData() {
        
        dataProfile = [
            [Information(title: R.stringLocalizable.inforStudentName(),
                         content: persionInformation?.name ?? "")],
            [Information(title: R.stringLocalizable.inforStudentDateOfBirth(),
                         content: persionInformation?.date_Of_Birth ?? ""),
             Information(title:  R.stringLocalizable.inforStudentSex(),
                         content: persionInformation?.gender ?? "")],
            [Information(title: R.stringLocalizable.inforStudentPlaceOfBirth(),
                         content: persionInformation?.place_Of_Birth ?? "")],
            [Information(title: R.stringLocalizable.inforStudentNation(),
                         content: persionInformation?.nation ?? ""),
             Information(title: R.stringLocalizable.inforStudentReligion(),
                         content: persionInformation?.religion ?? "")],
            [Information(title: R.stringLocalizable.inforStudentPhoneNumber(),
                         content: persionInformation?.phoneNumber ?? "")],
            [Information(title: R.stringLocalizable.inforStudentCitizentId(),
                         content: persionInformation?.citizentId ?? "") ],
            [Information(title: R.stringLocalizable.inforStudentDateRange(),
                         content: persionInformation?.date_Of_Range ?? ""),
             Information(title: R.stringLocalizable.inforStudentAddressRange(),
                         content: persionInformation?.address_Of_Range ?? "")]]
        
        dataStudent  = [
            [Information(title: R.stringLocalizable.inforStudentEmail(),
                         content: studentInformation?.email ?? "")],
            [Information(title: R.stringLocalizable.inforStudentStudentId(),
                         content: studentInformation?.student_Code ?? "")],
            [Information(title: R.stringLocalizable.inforStudentNation(),
                         content: persionInformation?.nation ?? ""),
             Information(title: R.stringLocalizable.inforStudentClass(),
                         content: studentInformation?.className ?? "")],
            [Information(title: R.stringLocalizable.inforStudentBatch(),
                         content: studentInformation?.batch ?? "")],
            [Information(title: R.stringLocalizable.inforStudentFaculty(),
                         content: studentInformation?.faculaty ?? "")],
            [Information(title: R.stringLocalizable.inforStudentBatch(),
                         content: studentInformation?.major ?? "") ],
            [Information(title: R.stringLocalizable.inforStudentYearOfAdmission(),
                         content: String(studentInformation?.year_Of_Admission ?? 0)),
             Information(title: R.stringLocalizable.inforStudentYearOfHighSchoolGraduation(),
                         content: String(studentInformation?.year_Of_HighSchool_Graduation ?? 0))],
            [Information(title: R.stringLocalizable.inforStudentAccountNumber(),
                         content: studentInformation?.bankName ?? ""),
             Information(title: R.stringLocalizable.inforStudentBankName(),
                         content: studentInformation?.bankName ?? "")],
        ]
        informationTableView.reloadData()
    }
}

extension InformationStudentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataProfile.count
        } else {
            return dataStudent.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
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
        } else {
            let data = dataStudent[indexPath.row]
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

