//
//  Alert.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func show(message: String,
              title: String? = nil,
              cancelTitle: String = R.stringLocalizable.buttonCancle(),
              okTitle: String = R.stringLocalizable.buttonOk(),
              okAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default, handler: okAction)
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
