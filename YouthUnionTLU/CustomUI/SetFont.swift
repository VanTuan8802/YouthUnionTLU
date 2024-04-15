//
//  SetFont.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 15/4/24.
//

import Foundation
import UIKit

extension UILabel {
    func setFont(name: String, size: CGFloat) {
        self.font = UIFont(name: name, size: size)
    }
}

extension UIButton {
    func setFont(name: String, size: CGFloat) {
        self.titleLabel?.font = UIFont(name: name, size: size)
    }
}

extension UITextField {
    func setFont(name: String, size: CGFloat) {
        self.font = UIFont(name: name, size: size)
    }
}
