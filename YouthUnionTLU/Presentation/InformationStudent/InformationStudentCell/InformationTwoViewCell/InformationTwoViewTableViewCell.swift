//
//  InformationTwoViewTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 17/05/2024.
//

import UIKit

class InformationTwoViewTableViewCell: UITableViewCell {

    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var leftContent: UITextField!
    @IBOutlet weak var rightLable: UILabel!
    @IBOutlet weak var rightContent: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftContent.addPadding()
        rightContent.addPadding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bindData(information: [Information]) {
        leftTitle.text = information[0].title
        leftContent.text = information[0].content
        
        rightLable.text = information[1].title
        rightContent.text = information[1].content
    }
    
}
