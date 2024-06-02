//
//  PointTraining.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 2/6/24.
//

import Foundation

struct PointTraining: Decodable {
    var term: String
    var score: Int
}

struct PointTrainingYear: Decodable {
    var year: String
    var points: [PointTraining]
}
