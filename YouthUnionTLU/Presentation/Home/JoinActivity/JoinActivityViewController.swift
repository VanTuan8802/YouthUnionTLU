//
//  JoinActivityViewController.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 27/6/24.
//

import UIKit

class JoinActivityViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var studentCode: UITextField!
    @IBOutlet weak var classTxt: UITextField!
    @IBOutlet weak var nameStudentCode: UITextField!
    @IBOutlet weak var seatTxt: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    private var viewModel: JoinActivityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    class func create(with viewModel: JoinActivityViewModel) -> JoinActivityViewController {
        let vc = JoinActivityViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    @IBAction func joinActivityAction(_ sender: Any) {
//        FSStorageClient.shared.uploadImage(image: image.image ?? <#default value#>, path: <#T##String#>, completion: <#T##(Result<String, Error>) -> Void#>)
    }
    
}
