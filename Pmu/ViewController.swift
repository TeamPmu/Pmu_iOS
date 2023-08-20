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
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print("loginWithKakaoTalk() success.")
                    
                    self.checkAppMembershipAndProceed(with: oauthToken.accessToken)
                }
            }
        }
        
        else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print("카카오 계정으로 로그인 성공")
                    
                    self.checkAppMembershipAndProceed(with: oauthToken.accessToken)
                }
            }
        }
    }
    
    func checkAppMembershipAndProceed(with token: String) {
        if let savedToken = UserDefaults.standard.string(forKey: "token") {
            if savedToken == token {
                // 토큰이 저장되어 있는 경우, 회원 정보 확인 후 로그인 또는 회원 가입
                KakaoLoginService.login(auth: token) { networkResult in
                    switch networkResult {
                    case .success(let kakaoResponse):
                        // 회원 정보가 있는 경우
                        /*let MainVC = UIStoryboard(name: "Main", bundle: nil)
                            .instantiateViewController(withIdentifier: "Main")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainVC, animated: true)
                        */
                        self.signIn(with: token)
                        
                    case .requestErr(let kakaoResponse):
                        // 회원 정보가 없는 경우
                        UserDefaults.standard.set(token, forKey: "token")
                        self.presentSignUpViewController()
                    case .pathErr, .serverErr, .networkFail:
                        // 에러 처리
                        print("서버 에러")
                    }
                }
            } else {
                // 토큰이 저장되어 있지 않거나 다른 토큰인 경우
                UserDefaults.standard.set(token, forKey: "token")
                self.presentSignUpViewController()
            }
        } else {
            // 토큰이 저장되어 있지 않은 경우
            UserDefaults.standard.set(token, forKey: "token")
            self.presentSignUpViewController()
        }
    }

    func presentSignUpViewController() {
        guard let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController else { return }
        signUpVC.modalTransitionStyle = .coverVertical
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }

    
    func signIn(with token: String) {
        // 이 함수 내에서 KakaoLoginService의 메서드를 호출하면서 토큰을 전달합니다.
        KakaoLoginService.login(auth: token) { networkResult in
            switch networkResult {
            case .success(_):
                // 로그인 성공 시 처리
                print("로그인 성공")
            case .requestErr(_):
                print("login requestErr")
            case .pathErr:
                print("login pathErr")
            case .serverErr:
                print("login serverErr")
            case .networkFail:
                print("login networkFail")
            }
        }
    }
    
    // Helper method to display alerts
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

/*extension ViewController {
    func signIn() {
        /*     KakaoLoginService.shared.login { result in
         switch result {
         case .success(_):
         print("로그인 성공")
         case .badRequest: //400 잘못된 요청
         print("400 잘못된 요청")
         case .unauthorized: //401 리소스 접근 권한 없음, 토큰 조회 오류
         print("401 리소스 접근 권한 없음, 토큰 조회 오류")
         case .forbidden: // 403 리소스 접근 권한 없음
         print("403 리소스 접근 권한 없음")
         case .notFound: //404 엔티티 없거나, 회원 찾기 불가
         print("404 엔티티 없거나, 회원 찾기 불가")
         case .methodNotAllowed: //405 잘못된 HTTP method 요청
         print("405 잘못된 HTTP method 요청")
         case .conflict: //409 이미 존재하는 리소스
         print("409 이미 존재하는 리소스")
         case .internalServerError: // 500 서버 내부 오류
         print("500 서버 내부 오류")
         case .unknown:
         print("실패")
         }
         }
         }*/
        // oauthToken 변수에서 토큰 값을 가져와서 auth 변수에 할당
        guard let oauthToken = AccessToken.current?.accessToken else {
            print("토큰이 없습니다.")
            return
        }

        KakaoLoginService.login(auth: oauthToken){
            (networkResult) in
            switch networkResult{
            case .success(let kakaoResponse):
                //let user : User = data
                // 유저 정보 저장해놓는 로직 넣기
                //UserManager.shared.setUser(user)
                //self.goToMainPage()
                
                // 여기서 kakaoResponse의 값을 활용하여 필요한 작업을 수행
                print("로그인 성공")
                
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
                
            }
        }
    }
}*/
