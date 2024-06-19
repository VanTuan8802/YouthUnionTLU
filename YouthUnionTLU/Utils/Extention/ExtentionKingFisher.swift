//
//  ExtentionKingFisher.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 13/6/24.
//

import Foundation
import UIKit

func updateImageContentSize(imageView: UIImageView ,with imageLink: String) {
    guard let url = URL(string: imageLink) else {
        return
    }
    
    imageView.kf.setImage(with: url) { result in
        switch result {
        case .success(let value):
            
            let imageSize = value.image.size
            
            let screenWidth = UIScreen.main.bounds.width
            
            let aspectRatio = imageSize.width / imageSize.height
            let newHeight = screenWidth / aspectRatio
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: screenWidth),
                imageView.heightAnchor.constraint(equalToConstant: newHeight)
            ])
            
            imageView.layoutIfNeeded()
        case .failure(let error):
            print("Error loading image: \(error)")
        }
    }
}
