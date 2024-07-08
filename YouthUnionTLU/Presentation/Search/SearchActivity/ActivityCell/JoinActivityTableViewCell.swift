//
//  JoinActivityTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 1/7/24.
//

import UIKit

class JoinActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var nameActivityLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var timeValueLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var addressValueLb: UILabel!
    @IBOutlet weak var seatLb: UILabel!
    @IBOutlet weak var seatValue: UILabel!
    @IBOutlet weak var imageJoinActivity: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchData(joinActivity: JoinActivityModel) {
       nameActivityLb.text = joinActivity.nameActivity
//        timeLb.text = joinActivity.t
    }
    
}
