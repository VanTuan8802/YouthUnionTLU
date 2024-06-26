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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchData(content: ContentMock) {
        if content.contentType == .image {
            guard let image = content.imageContent else { return }
            
            imageContent.image = image
            imageContent.isHidden = false
            textContent.isHidden = true
            
            let imageSize = image.size
            let screenWidth = UIScreen.main.bounds.width
            
            let aspectRatio = imageSize.width / imageSize.height
            let newHeight = screenWidth / aspectRatio
            
            imageContent.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.deactivate(imageContent.constraints)
            
            NSLayoutConstraint.activate([
                imageContent.widthAnchor.constraint(equalToConstant: screenWidth),
                imageContent.heightAnchor.constraint(equalToConstant: newHeight),
                imageContent.centerXAnchor.constraint(equalTo: imageContent.superview!.centerXAnchor),
                imageContent.centerYAnchor.constraint(equalTo: imageContent.superview!.centerYAnchor)
            ])
            
            imageContent.contentMode = .scaleAspectFit
            self.imageContent.layoutIfNeeded()
        } else {
            textContent.text = content.textContent
            textContent.isHidden = false
            imageContent.isHidden = true
            self.imageContent.layoutIfNeeded()
        }
    }
}
