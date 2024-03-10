//
//  SplashViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import UIKit

class SplashViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: SplashViewModel!
    
    class func create(with viewModel: SplashViewModel) -> SplashViewController {
        let vc = SplashViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
