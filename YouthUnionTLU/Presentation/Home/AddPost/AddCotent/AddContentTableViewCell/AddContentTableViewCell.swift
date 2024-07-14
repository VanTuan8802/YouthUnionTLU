//
//  AddContentTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 17/6/24.
//

import UIKit

class AddContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var textContent: UITextView!
    
    var imageCallback: ((UIImageView, IndexPath) -> Void)?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func changeImageAction(_ sender: Any) {
        if let callback = imageCallback, let indexPath = indexPath {
            callback(imageContent, indexPath)
            self.imageContent.layoutIfNeeded()
        }
    }
    
    func fetchData(content: ContentMock, at indexPath: IndexPath) {
        self.indexPath = indexPath
        
        if content.contentType == .image {
            guard let image = content.imageContent else { return }
            
            imageContent.image = image
            imageContent.isHidden = false
            textContent.isHidden = true
            
            let imageSize = image.size
            let cellWidth = self.contentView.frame.width
            
            let aspectRatio = imageSize.width / imageSize.height
            let newHeight = cellWidth / aspectRatio
            
            imageContent.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.deactivate(imageContent.constraints)
            
            NSLayoutConstraint.activate([
                imageContent.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                imageContent.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                imageContent.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                imageContent.heightAnchor.constraint(equalToConstant: newHeight)
            ])
            
            imageContent.contentMode = .scaleToFill
            self.layoutIfNeeded()
        } else {
            textContent.text = content.textContent
            textContent.isHidden = false
            imageContent.isHidden = true
            self.layoutIfNeeded()
        }
    }

}


