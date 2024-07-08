//
//  PointTrainingTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 4/6/24.
//

import UIKit

class PointTrainingTableViewCell: UITableViewCell {

    @IBOutlet weak var yearValue: UILabel!
    @IBOutlet weak var yearScore: UILabel!
    @IBOutlet weak var yearClassificationLb: UILabel!
    @IBOutlet weak var term1Lb: UILabel!
    @IBOutlet weak var term1ScoreLb: UILabel!
    @IBOutlet weak var term1ClassificationLb: UILabel!
    @IBOutlet weak var term2Lb: UILabel!
    @IBOutlet weak var term2Score: UILabel!
    @IBOutlet weak var term2ClassificationLb: UILabel!
    @IBOutlet weak var viewScoreTerm2: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchData(pointTraing: PointTrainingYear) {
        yearValue.text = pointTraing.year
        
        term1Lb.text = "1-\(pointTraing.year)"
        term1ScoreLb.text = String(pointTraing.points.term1)
        term1ClassificationLb.text = classification(score: pointTraing.points.term1)
        
        guard let term2ScoreValue = pointTraing.points.term2  else {
            yearScore.text = String(pointTraing.points.term1)
            yearClassificationLb.text = classification(score: pointTraing.points.term1)
            viewScoreTerm2.isHidden = true
            return
        }
        
        let scoreYear = (pointTraing.points.term1 + term2ScoreValue) / 2
        term2Lb.text = "2-\(pointTraing.year)"
        term2Score.text = String(term2ScoreValue)
        term2ClassificationLb.text = classification(score: scoreYear)
        
        yearScore.text = String(scoreYear)
        yearClassificationLb.text = classification(score: scoreYear)
        
    }
    
    private func classification(score: Double) -> String {
        if score >= 90 {
            return "Xuất sắc"
        } else if score >= 80 {
            return "Tốt"
        } else if score >= 65 {
            return "Khá"
        } else if score >= 50 {
            return "Trung bình"
        } else if score >= 35 {
            return "Yếu"
        } else {
            return "Kém"
        }
    }
}
