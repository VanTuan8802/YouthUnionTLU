//
//  DocumentTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 12/6/24.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageDocumnet: UIImageView!
    @IBOutlet weak var titleDocument: UILabel!
    @IBOutlet weak var dateCreateDocument: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchData(document: DocumnetModel) {
        imageDocumnet.kf.setImage(with: URL(string: document.pathImage))
        titleDocument.text = document.title
        dateCreateDocument.text = document.createDay.description
    }
}
