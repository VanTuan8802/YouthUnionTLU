//
//  CustomStyleTabBarContentView.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 21/03/2024.
//

import Foundation
import ESTabBarController_swift

class CustomStyleTabBarContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconColor = UIColor.red
        
        highlightIconColor = .white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
