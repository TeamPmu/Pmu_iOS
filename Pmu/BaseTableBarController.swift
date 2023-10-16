//
//  BaseTBC.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit

class BaseTableBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭 바 배경색 변경
        tabBar.barTintColor = UIColor.white // 원하는 배경색으로 변경
        
        // 탭 바 경계(border) 제거
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor
    }
}
