//
//  PostActivityTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 13/6/24.
//

import UIKit
import Kingfisher

class PostActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var imageActivities: UIImageView!
    @IBOutlet weak var titleActivity: UILabel!
    @IBOutlet weak var dateCreate: UILabel!
    @IBOutlet weak var timeStartLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchData(postActivity: PostModel) {
        imageActivities.kf.setImage(with: URL(string: postActivity.imageNew))
        titleActivity.text = postActivity.title
        dateCreate.text = convertTimestampToString(timestamp: postActivity.timeCreate)
        guard let timeCreate = postActivity.timeStartActivy else {
            return
        }
        timeStartLb.text = convertTimestampToString(timestamp: timeCreate)
    }
}
