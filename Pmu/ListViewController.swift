//
//  ListViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.barTintColor = UIColor.white // 또는 원하는 배경색
        self.tabBarController?.tabBar.layer.borderWidth = 0
        self.tabBarController?.tabBar.layer.borderColor = UIColor.clear.cgColor
    }
}
