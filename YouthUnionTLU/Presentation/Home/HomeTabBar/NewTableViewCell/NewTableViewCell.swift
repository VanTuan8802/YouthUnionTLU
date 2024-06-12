//
//  NewTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 8/6/24.
//

import UIKit
import Kingfisher

class NewTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNew: UIImageView!
    @IBOutlet weak var titleNew: UILabel!
    @IBOutlet weak var timeCreate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   
    }
    
    func fetchData(new: NewModel) {
        imageNew.kf.setImage(with: URL(string: new.imageNew))
        titleNew.text = new.title
        timeCreate.text = convertTimestampToString(timestamp: new.timeCreate)
    }
    
    
    
}
