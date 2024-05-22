//
//  InformationOneViewTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 17/05/2024.
//

import UIKit

class InformationOneViewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var contentTxt: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTxt.addPadding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bindData(infomation: [Information]) {
        titleLb.text = infomation[0].title
        contentTxt.text = infomation[0].content
    }
}
