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
        
        //getFontName()
    }
    
    @IBAction func logInBtnTapped(_ sender: UIButton) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print("loginWithKakaoTalk() success.")
                    
                    // AccessToken을 Keychain에 저장
                    KeyChain.saveToken(oauthToken.accessToken, forKey: "accessToken")
                    
                    // 로그인 처리
                    self.signIn(with: oauthToken.accessToken)
                    //self.presentMainViewController()
                    
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print("카카오 계정으로 로그인 성공")
                    
                    // AccessToken을 Keychain에 저장
                    KeyChain.saveToken(oauthToken.accessToken, forKey: "accessToken")
                    
                    // 로그인 처리
                    self.signIn(with: oauthToken.accessToken)
                    //self.presentMainViewController()
                }
            }
        }
    }
    
    func checkAppMembershipAndProceed(with token: String) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print("loginWithKakaoTalk() success.")
                    self.signInAndCheckAppMembership(with: oauthToken.accessToken)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print("카카오 계정으로 로그인 성공")
                    self.signInAndCheckAppMembership(with: oauthToken.accessToken)
                }
            }
        }
    }
    
    func signInAndCheckAppMembership(with token: String) {
        KakaoLoginService.login(auth: token) { networkResult in
            switch networkResult {
            case .success(_):
                self.signIn(with: token)
            case .requestErr(_):
                self.presentSignUpViewController()
            case .pathErr, .serverErr, .networkFail:
                print("signInAndCheckAppMembership Network Error")
                DispatchQueue.main.async {
                    self.showAlert(title: "signInAndCheckAppMembership Network Error", message: "Please try again later.")
                }
            }
        }
    }
    
    func presentSignUpViewController() {
        guard let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController else { return }
        signUpVC.modalTransitionStyle = .coverVertical
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    func presentMainViewController() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Main")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(mainVC, animated: true)
    }
    
    func signIn(with token: String) {
        KakaoLoginService.login(auth: token) { networkResult in
            switch networkResult {
            case .success(let kakaoResponse):
                if let response = kakaoResponse as? KakaoLoginResponse {
                    let loginData = response.data
                    
                    if !loginData.accessToken.isEmpty {
                        DispatchQueue.main.async {
                            print("signIn 로그인 성공")
                            print("AccessToken: \(loginData.accessToken)")
                            print("RefreshToken: \(loginData.refreshToken)")
                            print("UserID: \(loginData.userID)")
                            print("ProfileImageURL: \(loginData.profileImageURL)")
                            print("Nickname: \(loginData.nickname)")
                            
                            self.presentMainViewController()
                        }
                    } else {
                        print("AccessToken is empty")
                        DispatchQueue.main.async {
                            self.showAlert(title: "signIn Error", message: "An error occurred while processing the response.")
                        }
                    }
                } else {
                    print("Response parsing error")
                    DispatchQueue.main.async {
                        self.showAlert(title: "signIn Error", message: "An error occurred while processing the response.")
                    }
                }
            case .requestErr(let errorData):
                print("Request Error:", errorData)
                DispatchQueue.main.async {
                    self.showAlert(title: "signIn Request Error", message: "Please try again.")
                }
            case .pathErr, .serverErr, .networkFail:
                print("Network Error")
                DispatchQueue.main.async {
                    self.showAlert(title: "signIn Network Error", message: "Please try again later.")
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    /*func getFontName() {
     for family in UIFont.familyNames {
     
     let sName: String = family as String
     print("family: \(sName)")
     
     for name in UIFont.fontNames(forFamilyName: sName) {
     print("name: \(name as String)")
     }
     }
     }*/
}
