//
//  CheckValidate.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import UIKit

extension String{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func checkEmail() -> (String, String)? {
        if self.isEmpty {
            return (R.stringLocalizable.errorEmailTitle(),
                    R.stringLocalizable.errorEmailMessageRequire())
        }
        
        if !self.isValidEmail() {
            return (R.stringLocalizable.errorEmailTitle(),
                    R.stringLocalizable.errorEmailMessage())
        }
        return nil
    }
    
    func checkPassword() -> (String, String)? {
        if self.isEmpty {
            return (R.stringLocalizable.errorPasswordTitle(),
                    R.stringLocalizable.errorPasswordMessageRequire())
        } else {
            if self.count < 8 || self.contains(" ") {
                return (R.stringLocalizable.errorPasswordTitle(),
                        R.stringLocalizable.errorPasswordMessage())
            }
        }
        return nil
    }

}
