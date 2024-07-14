//
//  ContentTableViewCell.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 10/6/24.
//

import UIKit
import Kingfisher

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var textContentTv: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func fetchData(content: ContentModel) {
        
        if content.contentType == .image {
            guard let imageLink = content.imageContent else {
                return
            }
            
            imageContent.isHidden = false
            imageContent.kf.setImage(with: URL(string: imageLink)) { result in
                switch result {
                case .success(let value):
                    let imageSize = value.image.size
                   
                    let screenWidth = UIScreen.main.bounds.width
                    
                    let aspectRatio = imageSize.width / imageSize.height
                    let newHeight = screenWidth / aspectRatio
                    
                    self.imageContent.translatesAutoresizingMaskIntoConstraints = false
                    self.imageContent.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
                    self.imageContent.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                    self.imageContent.layoutIfNeeded()
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
            textContentTv.isHidden = true
        } else {
            guard let textContent = content.textContent else {
                return
            }
            textContentTv.isHidden = false
            imageContent.isHidden = true
            textContentTv.text = textContent
            self.imageContent.layoutIfNeeded()
        }
    }
}
