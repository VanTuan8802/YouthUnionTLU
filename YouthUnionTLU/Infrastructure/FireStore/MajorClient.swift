//
//  MajorClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 28/5/24.
//

import Foundation

protocol MajorClient {
    func getListMajor(completion: @escaping([Major]?,Error?) -> Void)
    func getDataMajor(majorId: String, completion: @escaping(Major?,Error?) -> Void)
    func getListMajorId(completion: @escaping([String]?,Error?) -> Void)
}
