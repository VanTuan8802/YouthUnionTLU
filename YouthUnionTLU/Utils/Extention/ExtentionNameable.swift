//
//  ExtentionNameable.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import Foundation
import UIKit

protocol ClassNameable {
    static var className: String { get }
}

extension ClassNameable {
    static var className: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: Self.className, bundle: nil)
    }
    
    static func register(_ view: UICollectionView) {
        view.register(nib, forCellWithReuseIdentifier: className)
    }
    
    static func cell(for view: UICollectionView, at indextPath: IndexPath) -> Self? {
        view.dequeueReusableCell(withReuseIdentifier: className, for: indextPath) as? Self
    }
    
    static func register(_ view: UITableView) {
        view.register(nib, forCellReuseIdentifier: className)
    }
    
    static func cell(for view: UITableView, at indexPath: IndexPath) -> Self? {
        view.dequeueReusableCell(withIdentifier: className, for: indexPath) as? Self
    }
}

extension NSObject: ClassNameable {}
