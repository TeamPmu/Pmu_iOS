//
//  ViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {
    
    @IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getFontName()
    }
    
    /*func setUserInfo() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("nickname: \(user?.kakaoAccount?.profile?.nickname ?? "no nickname")")
                print("email: \(user?.kakaoAccount?.email ?? "no email")")
                
                guard let userId = user?.id else {return}
                
                print("닉네임 : \(user?.kakaoAccount?.profile?.nickname ?? "no nickname").....이메일 : \(user?.kakaoAccount?.email ?? "no nickname"). . . . .유저 ID : \(userId)")
                self.NickNameLabel.text = "Nickname : \(user?.kakaoAccount?.profile?.nickname ?? "no nickname")"
                self.EmailLabel.text = "Email : \(user?.kakaoAccount?.email ?? "no nickname")"
            }
        }
    }*/
    
    @IBAction func logInBtnTapped(_ sender: UIButton) {
        /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
        if let SignUpVC = storyboard.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = SignUpVC
            }
        } */
        
        /*let SignUpVC =  UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SignUp")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(SignUpVC, animated: true)*/
        
        // 카카오톡 설치 여부 확인
        /*if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        }*/
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    _ = oauthToken
                    
                    guard let SignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController else { return }
                        // 화면 전환 애니메이션 설정
                        SignUpVC.modalTransitionStyle = .coverVertical
                        // 전환된 화면이 보여지는 방법 설정 (fullScreen)
                        SignUpVC.modalPresentationStyle = .fullScreen
                        self.present(SignUpVC, animated: true, completion: nil)
                    
                    //UserDefaults.standard.set(_ = oauthToken, forKey: "token")
                    
                    //print(type(of: oauthToken))
                }
            }
        }
        
        else {
            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 로그인 성공")
                    _ = oauthToken
                    //UserDefaults.standard.set(_ = oauthToken, forKey: "token")
                    
                    guard let SignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController else { return }
                        // 화면 전환 애니메이션 설정
                        SignUpVC.modalTransitionStyle = .coverVertical
                        // 전환된 화면이 보여지는 방법 설정 (fullScreen)
                        SignUpVC.modalPresentationStyle = .fullScreen
                        self.present(SignUpVC, animated: true, completion: nil)
                }
            }
        }
    }
    

    func getFontName() {
            for family in UIFont.familyNames {

                let sName: String = family as String
                print("family: \(sName)")
                        
                for name in UIFont.fontNames(forFamilyName: sName) {
                    print("name: \(name as String)")
                }
            }
        }
}

