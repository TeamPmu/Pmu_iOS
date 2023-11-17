//
//  MusicListNavigationViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/29.
//

import UIKit

class MusicListNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.isToolbarHidden = true
        
        self.tabBarController?.tabBar.barTintColor = UIColor.white // 또는 원하는 배경색
        self.tabBarController?.tabBar.layer.borderWidth = 0
        self.tabBarController?.tabBar.layer.borderColor = UIColor.clear.cgColor
    }
}
