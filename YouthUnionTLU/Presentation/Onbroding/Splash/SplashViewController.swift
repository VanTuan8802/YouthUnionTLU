//
//  SplashViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import UIKit

class SplashViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var progressView: UIProgressView!
    private var viewModel: SplashViewModel!
    
    class func create(with viewModel: SplashViewModel) -> SplashViewController {
        let vc = SplashViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
        self.progressView.setProgress(2.2, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.viewModel.openFirstLanguage()
        })
    }
    
    private func bind(to viewModel: SplashViewModel) {
    }
}

extension SplashViewController {
    
}
