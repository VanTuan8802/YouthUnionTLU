//
//  Student.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation

struct Address: Codable {
    let ward: String
    let district: String
    let city: String
}

struct Student: Codable{
    let id: String
    let name: String
    let avatarUrl: String
    let date_Of_Birth: String
    let sex: String
    let address: Address
    let nation: String
    let religion: String
    let phoneNumber: String
    let citizenId: String
    let date_Range: String
    let address_Range: String
    let className: String
    let batch: String
    let faculaty: String
    let major: String
    let email: String
    let year_Of_Admission: Int
    let year_Of_HighSchool_Graduation: String
    let account_Number: String
    let bank: String
}
