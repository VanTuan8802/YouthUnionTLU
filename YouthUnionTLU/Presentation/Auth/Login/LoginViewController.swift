//
//  LoginViewController.swift
//  YouthUnionTLU
//
//  Created by VanTuan on 20/03/2024.
//

import UIKit

class LoginViewController: UIViewController, StoryboardInstantiable {

    private var viewModel: LoginViewModel!
    
    class func create(with viewModel: LoginViewModel) -> LoginViewController {
        let vc = LoginViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
