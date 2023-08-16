//
//  MyPageViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var documentBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var unregisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        profileImg.layer.cornerRadius = 80
        profileImg.clipsToBounds = true
        
        StackView.layer.cornerRadius = 10
        StackView.clipsToBounds = true
        
    }
    
    
    @IBAction func documentBtnTapped(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/TeamPmu/Pmu_iOS") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func logOutBtnTapped(_ sender: UIButton) {
        UserApi.shared.logout{(error) in
            if let error = error {
                print(error)
            } else {
                print("kakao logout success")
                //UserDefaults.standard.removeObject(forKey: "token")
                
                /*guard let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
                        // 화면 전환 애니메이션 설정
                    firstViewController.modalTransitionStyle = .coverVertical
                    // 전환된 화면이 보여지는 방법 설정 (fullScreen)
                    firstViewController.modalPresentationStyle = .fullScreen
                    self.present(firstViewController, animated: true, completion: nil)*/
            }
        }
    }
    
    @IBAction func unregisterBtnTapped(_ sender: UIButton) {
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let UnregisterVC = storyboard.instantiateViewController(withIdentifier: "UnregisterVC") as? UnregisterViewController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = UnregisterVC
            }
        } */
        
        let UnregisterVC =  UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "UnregisterVC")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UnregisterVC, animated: true)
    }
    
    
}
