//
//  MajorClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 28/5/24.
//

import Foundation

protocol MajorClient {
    func getListMajoy(completion: @escaping([Major]?,Error?) -> Void)
    func getDataMajoy(majorId: String, completion: @escaping(Major?,Error?) -> Void)
}
