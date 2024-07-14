//
//  StorageClient.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 16/6/24.
//

import Foundation
import UIKit

protocol StorageClient {
    func uploadImage(index: Int?, image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void)
}
