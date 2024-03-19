//
//  LanguageTableViewCell.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 11/03/2024.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var imageCountry: UIImageView!
    @IBOutlet weak var nameCountry: UILabel!
    
    private var language: LanguageType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(language: LanguageType, selected: Bool) {
        self.language = language
        imageCountry.image = UIImage(named: language.image)
        nameCountry.text = language.name
        
        if selected {
            languageView.backgroundColor = R.color.d3BB6()
            languageView.layer.borderColor = UIColor.white.cgColor
            
        } else {
            languageView.backgroundColor = .white
            languageView.layer.borderColor = UIColor.white.cgColor
        }
    }
}
