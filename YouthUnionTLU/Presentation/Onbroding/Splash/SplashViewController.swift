//
//  SplashViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 10/03/2024.
//

import UIKit

class SplashViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var youthUnionLabel: UILabel!
    @IBOutlet weak var tluLabel: UILabel!
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
        
        setUI()
        self.progressView.setProgress(2.2, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.viewModel.openFirstLanguage()
        })
    }
    
    private func bind(to viewModel: SplashViewModel) {
    }
    
    private func setUI() {
        youthUnionLabel.setFont(name: AppFont.sf_pro_display_bold.rawValue, size: 56)
        tluLabel.setFont(name: AppFont.sf_pro_display_bold.rawValue, size: 26)
    }
}

extension SplashViewController {
    
}
