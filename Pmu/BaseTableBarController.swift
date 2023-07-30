//
//  BaseTBC.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit

class BaseTableBarController: UITabBarController {
    
    //let titles = ["홈", "Shorts", "추가", "구독", "보관함"]
    
    /*let defaultImages = [UIImage(named: "music.png"),UIImage(named: "list.png"),UIImage(named: "myPage.png")]
        
        let selectedImages = [UIImage(named: "musicFilled.png"),UIImage(named: "listFilled.png"),UIImage(named: "myPageFilled.png")]
        
        let views = [MusicViewController(),ListViewController(),MyPageViewController()]
        var VCs : [UINavigationController] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            views.forEach{
                VCs.append(UINavigationController(rootViewController: $0))
            }
            
            viewControllers = VCs
            
            viewControllers?.indices.forEach{
                viewControllers?[$0].tabBarItem = UITabBarItem(title: nil, image: defaultImages[$0], selectedImage: selectedImages[$0])
            }
            
            //나중에 플러스 아이콘만 modal로 present 될 경우를 대비하여 delegate 코드 미리 추가했습니다!
            self.delegate = self

            UITabBar.appearance().barTintColor = .white
            UITabBar.appearance().tintColor = .black
            UITabBar.appearance().isTranslucent = false
            
            tabBar.items?[4].badgeValue = "1"
            
            if #available(iOS 15, *) {
                let appearance = UITabBarAppearance()
                let tabBar = UITabBar()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white
                appearance.selectionIndicatorTintColor = .black
                tabBar.standardAppearance = appearance;
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }*/
}

/* extension BaseTableBarController: UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.badgeValue = nil
    }
} */
