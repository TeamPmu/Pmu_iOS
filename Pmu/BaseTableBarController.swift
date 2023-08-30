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
    
    /*if var response = KakaoLoginResponse {
        // 성공 응답을 파싱하여 데이터에 접근
        let loginData = response.data
        print("로그인 성공")
        print("AccessToken: \(loginData.accessToken)")
        print("RefreshToken: \(loginData.refreshToken)")
        print("UserID: \(loginData.userID)")
        print("ProfileImageURL: \(loginData.profileImageURL)")
        print("Nickname: \(loginData.nickname)")
    }*/
}

/* extension BaseTableBarController: UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.badgeValue = nil
    }
} */
