//
//  MyPageViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var profileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        profileImg.layer.cornerRadius = 80
        profileImg.clipsToBounds = true
        
        StackView.layer.cornerRadius = 10
        StackView.clipsToBounds = true
        
    }
    
}
