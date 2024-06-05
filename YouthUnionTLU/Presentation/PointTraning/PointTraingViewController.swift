//
//  PointTraingViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 2/6/24.
//

import UIKit

class PointTraingViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var nameValueLb: UILabel!
    @IBOutlet weak var classLb: UILabel!
    @IBOutlet weak var classValue: UILabel!
    @IBOutlet weak var studentCodeLb: UILabel!
    @IBOutlet weak var studentCodeValue: UILabel!
    @IBOutlet weak var majoyLb: UILabel!
    @IBOutlet weak var majoyValue: UILabel!
    @IBOutlet weak var pointTrainingTableView: UITableView!
    
    private var viewModel: PointTrainingViewModel!
    private var listPoint: [PointTrainingYear] = []
    private var profileStudent: ProfileStudent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bindData(to: viewModel)
        setUpTableView()
        setUI()
    }
    
    class func create(with viewModel: PointTrainingViewModel) -> PointTraingViewController {
        let vc = PointTraingViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private func bindData(to viewMoldel:PointTrainingViewModel) {
        viewMoldel.listPoint.observe(on: self) { listPoint in
            guard let listPoint = listPoint else {
                return
            }
            
            self.listPoint = listPoint
            
            self.pointTrainingTableView.reloadData()
        }
        
        viewModel.profileStudent.observe(on: self) { profileStudent in
            guard let profileStudent = profileStudent else {
                return
            }
            
            self.nameValueLb.text = profileStudent.name
            self.studentCodeValue.text = profileStudent.student_Code
            self.classValue.text = profileStudent.className
            self.majoyValue.text = profileStudent.major
        }
        
        viewMoldel.error.observe(on: self) {error in
            guard error != nil else {
                return
            }
            
        }
    }
    
    private func setUI() {
        nameLb.text = "\(R.stringLocalizable.inforStudentName()): "
        studentCodeLb.text = "\(R.stringLocalizable.inforStudentStudentId()): "
        classLb.text = "\(R.stringLocalizable.inforStudentClass()): "
        majoyLb.text = "\(R.stringLocalizable.inforStudentMajor()): "
    }
    
    private func setUpTableView() {
        pointTrainingTableView.delegate = self
        pointTrainingTableView.dataSource = self
        
        pointTrainingTableView.register(UINib(nibName: PointTrainingTableViewCell.className, bundle: nil ), forCellReuseIdentifier: PointTrainingTableViewCell.className)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension PointTraingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPoint.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = listPoint.reversed()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PointTrainingTableViewCell.className, for: indexPath) as! PointTrainingTableViewCell
        cell.fetchData(pointTraing: data)
        return cell
    }
}


extension PointTraingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == pointTrainingTableView {
            if pointTrainingTableView.contentOffset.x != 0 {
                pointTrainingTableView.contentOffset.x = 0
            }
        }
    }
}
