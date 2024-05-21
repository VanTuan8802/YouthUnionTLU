//
//  InformationStudentViewModel.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 19/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct InformationStudentActions {
    let showSearchInformation: () -> Void
    let showSetting: () -> Void
}

protocol InformationStudentViewModelInput {
    func viewDidLoad()
    func openSearchInformation()
    func openSetting()
}

protocol InformationStudentViewModelOutput {
    var error: Observable<String?> {get}
    var persionalInformation: Observable<PersionalInformation?> {get}
    var studentInformation: Observable<StudentInformation?> {get}
}

protocol InformationStudentViewModel: InformationStudentViewModelInput, InformationStudentViewModelOutput {
    
}

class DefaultInformationStudentViewModel: InformationStudentViewModel {
    private let uid = Auth.auth().currentUser?.uid
    
    var error: Observable<String?> = Observable(nil)
    var persionalInformation: Observable<PersionalInformation?> = Observable(nil)
    var studentInformation: Observable<StudentInformation?> = Observable(nil)
    
    private let actions: InformationStudentActions?
    
    init(actions: InformationStudentActions?) {
        self.actions = actions
    }
    
    func viewDidLoad() {
        getDataStudent {
           
        }
    }

    func openSearchInformation() {
        // Thực hiện các hành động khi mở tìm kiếm thông tin
    }

    func openSetting() {
        // Thực hiện các hành động khi mở cài đặt
    }

    private func getDataStudent(completion: @escaping () -> Void) {
        var studentCode: String = ""
        
        if UserDefaultsData.shared.posision == Position.member.rawValue {
            studentCode = UserDefaultsData.shared.studentCode
        }
        
        let group = DispatchGroup()
        
        // Lấy dữ liệu thông tin cá nhân
        group.enter()
        FSUserClient.shared.getDataProfile(studentCode: studentCode) { personalInformationData, error in
            defer {
                group.leave()
            }
            
            if let error = error {
                print("Error fetching personal information: \(error.localizedDescription)")
                // Xử lý lỗi nếu cần
                return
            }
            
            guard let personalInformationData = personalInformationData else {
                print("Personal information data is nil")
                // Xử lý khi dữ liệu nil nếu cần
                return
            }
            
            self.persionalInformation.value = personalInformationData
        }
        
        // Lấy dữ liệu thông tin sinh viên
        group.enter()
        FSUserClient.shared.getDataStudent(studentCode: studentCode) { studentInformationData, error in
            defer {
                group.leave()
            }
            
            if let error = error {
                print("Error fetching student information: \(error.localizedDescription)")
                // Xử lý lỗi nếu cần
                return
            }
            
            guard let studentInformationData = studentInformationData else {
                print("Student information data is nil")
                // Xử lý khi dữ liệu nil nếu cần
                return
            }
            
            self.studentInformation.value = studentInformationData
        }
        
        // Hoàn thành khi cả hai công việc đã kết thúc
        group.notify(queue: .main) {
            // Gọi completion handler khi tất cả dữ liệu đã được lấy và gán
            completion()
        }
    }

}
