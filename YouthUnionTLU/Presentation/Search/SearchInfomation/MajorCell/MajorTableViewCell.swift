//
//  MajorTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 29/5/24.
//

import UIKit

class MajorTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var nameMajorLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func fetchData(major: Major) {
        nameMajorLb.text = major.name
    }
    
}
