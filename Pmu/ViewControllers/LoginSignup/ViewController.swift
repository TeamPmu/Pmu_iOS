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
    
    lazy var activityIndicator: UIActivityIndicatorView = { // indicator가 사용될 때까지 인스턴스를 생성하지 않도록 lazy로 선언
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        //activityIndicator.center = self.splitViewController?.view.center ?? CGPoint() // indicator의 위치 설정
        activityIndicator.style = UIActivityIndicatorView.Style.large // indicator의 스타일 설정, large와 medium이 있음
        
        activityIndicator.startAnimating() // indicator 실행
        activityIndicator.isHidden = false
        
        indicatorBGView.isHidden = false
        indicatorLbl.isHidden = false
        
        return activityIndicator
    }()
    
    @IBOutlet weak var indicatorBGView: UIView!
    @IBOutlet weak var indicatorLbl: UILabel!
    
    @IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        indicatorBGView.isHidden = true
        indicatorLbl.isHidden = true
        
        // 자동 로그인 시도
        tryAutoLogin()
    }
    
    func stopActivityIndicator() {
        indicatorBGView.isHidden = true
        indicatorLbl.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func logInBtnTapped(_ sender: UIButton) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let oauthToken = oauthToken {
                    print("카카오톡으로 로그인 성공")
                    
                    // AccessToken을 Keychain에 저장
                    KeyChain.saveToken(oauthToken.accessToken, forKey: "accessToken")
                    
                    print("로그인 토큰: \(KeyChain.loadToken(forKey: "accessToken"))")
                    print("카카오 로그인 토큰: \(oauthToken.accessToken)")
                    print("프뮤로그인 토큰: \(KeyChain.loadToken(forKey: "pmuaccessToken"))")
                    
                    // 로그인 처리
                    self.signIn(with: oauthToken.accessToken)
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
                    
                    print("로그인 토큰: \(KeyChain.loadToken(forKey: "accessToken"))")
                    print("카카오 로그인 토큰: \(oauthToken.accessToken)")
                    print("프뮤로그인 토큰: \(KeyChain.loadToken(forKey: "pmuaccessToken"))")
                    
                    // 로그인 처리
                    self.signIn(with: oauthToken.accessToken)
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
                    
                    if response.status == 404 {
                        print(response.status)
                        
                        // 404 에러가 발생한 경우 회원가입 창으로 이동
                        //print("signIn 404 회원가입 진행")
                        self.presentSignUpViewController()
                        
                    } else if response.status == 200 {
                        let loginData = response.data
                        
                        print("signIn 로그인 성공")
                        print("AccessToken: \(loginData!.accessToken)")
                        print("RefreshToken: \(loginData!.refreshToken)")
                        print("UserID: \(loginData!.userID)")
                        print("ProfileImageURL: \(loginData!.profileImageURL)")
                        print("Nickname: \(loginData!.nickname)")
                        
                        // AccessToken을 Keychain에 저장
                        KeyChain.saveToken(loginData!.accessToken, forKey: "pmuaccessToken")
                        KeyChain.saveToken(loginData!.refreshToken, forKey: "pmurefreshToken")
                        UserDefaults.standard.set(loginData!.userID, forKey: "userId")
                        
                        if let profileImgURLString = loginData!.profileImageURL {
                            self.view.addSubview(self.activityIndicator)
                            //self.view.bringSubviewToFront(self.activityIndicator)
                            //self.imgToEmotion(profileURL: profileImgURLString)
                            //indicator start
                            
                            //임의 설정
                            self.imgToEmotion(profileURL: "https://image.news1.kr/system/photos/2023/3/17/5888431/article.jpg/dims/quality/80/optimize")
                        }
                        //self.presentMainViewController()
                        //self.presentEmotionIndicatorViewController()
                    }
                    
                    /*if let accessToken = loginData?.accessToken {
                        print("signIn 로그인 성공")
                        print("AccessToken: \(loginData!.accessToken)")
                        print("RefreshToken: \(loginData!.refreshToken)")
                        print("UserID: \(loginData!.userID)")
                        print("ProfileImageURL: \(loginData!.profileImageURL)")
                        print("Nickname: \(loginData!.nickname)")
                        
                        // AccessToken을 Keychain에 저장
                        KeyChain.saveToken(loginData!.accessToken, forKey: "pmuaccessToken")
                        KeyChain.saveToken(loginData!.refreshToken, forKey: "pmurefreshToken")
                        UserDefaults.standard.set(loginData!.userID, forKey: "userId")
                        
                        self.presentMainViewController()
                    } else {
                        print("AccessToken is nil")
                        
                        // 404 에러가 발생한 경우 회원가입 창으로 이동
                        //print("signIn 404 회원가입 진행")
                        self.presentSignUpViewController()
                    }*/
                    
                } else {
                    print("Response parsing error")
                    DispatchQueue.main.async {
                        self.showAlert(title: "signIn Error", message: "An error occurred while processing the response.")
                    }
                }
            case .requestErr(let errorData):
                print("Request Error:", errorData)
                print("statusCode: ", errorData.status)
                DispatchQueue.main.async {
                    if errorData.status == 404 {
                        // 404 에러가 발생한 경우 회원가입 창으로 이동
                        print("signIn 404 회원가입 진행")
                        self.presentSignUpViewController()
                        
                    } else {
                        self.showAlert(title: "signIn Request Error", message: "Please try again.")
                    }
                }
            case .pathErr:
                print("pathErr Error")
            case .serverErr:
                print("serverErr Error")
            case .networkFail:
                print("networkFail Error")
                DispatchQueue.main.async {
                    self.showAlert(title: "signIn Network Error", message: "Please try again later.")
                }
            }
        }
    }
    
    // 액세스 토큰을 갱신하고 진행하는 함수
    /*func refreshAccessTokenAndProceed() {
        refreshAccessToken() { (success) in
            if success {
                // 갱신이 성공한 경우 로그인 또는 회원 가입 처리를 진행
                if let savedToken = KeyChain.loadToken(forKey: "pmuaccessToken") {
                    self.signIn(with: savedToken)
                } else {
                    self.presentSignUpViewController()
                }
            } else {
                // 갱신이 실패한 경우 에러 처리
                print("액세스 토큰 갱신 실패")
                // 에러 메시지를 사용자에게 표시하거나 다른 처리를 수행할 수 있습니다.
            }
        }
    }*/
    
    // 자동 로그인 시도하는 함수
    func tryAutoLogin() {
        // KeyChain에서 저장된 토큰을 불러옵니다.
        if let savedToken = KeyChain.loadToken(forKey: "accessToken") {
            // 저장된 토큰이 있는 경우 자동 로그인을 시도합니다.
            self.signIn(with: savedToken)
        } else if let refreshToken = KeyChain.loadToken(forKey: "pmurefreshToken") {
            // 저장된 토큰이 없고 대신 refreshToken이 있는 경우 JWT 토큰을 요청하고 응답을 처리합니다.
            let authorizationHeader = "Bearer \(refreshToken)" // 사용자 refreshToken을 Bearer 토큰 형식으로 설정
            jwtTokenService.jwtToken(auth: authorizationHeader, userId: UserDefaults.standard.integer(forKey: "userId")) { result in
                switch result {
                case .success(let jwtResponse):
                    // JWT 토큰 요청 성공, jwtResponse에 응답 데이터가 포함됩니다.
                    print("JWT 토큰 요청 성공")
                    print("AccessToken: \(jwtResponse.data!.accessToken)")
                    print("RefreshToken: \(jwtResponse.data!.refreshToken)")
                    
                    // JWT 토큰을 저장합니다.
                    KeyChain.saveToken(jwtResponse.data!.accessToken, forKey: "pmuaccessToken")
                    KeyChain.saveToken(jwtResponse.data!.refreshToken, forKey: "pmurefreshToken")
                    
                    // 자동 로그인 또는 다른 작업 수행 가능
                    self.signIn(with: jwtResponse.data!.accessToken)
                    self.showAlert(title: "자동 로그인", message: "자동 로그인 되었습니다.")
                    
                case .requestErr(let errorData):
                    // 요청 오류 처리
                    print("JWT 토큰 요청 실패 - 요청 오류")
                    // 자동 로그인 실패 처리 등을 수행하세요.
                    
                case .serverErr:
                    // 서버 오류 처리
                    print("JWT 토큰 요청 실패 - 서버 오류")
                    // 자동 로그인 실패 처리 등을 수행하세요.
                    
                case .networkFail:
                    // 네트워크 오류 처리
                    print("JWT 토큰 요청 실패 - 네트워크 오류")
                    // 자동 로그인 실패 처리 등을 수행하세요.
                    
                case .pathErr:
                    print("JWT 토큰 요청 실패 - 경로 오류")
                }
            }
        }
    }
    
    //APIgateway 프사url 전달
    func imgToEmotion(profileURL: String){
        ImgToEmotionService.ImgToEmotion(profileURL: profileURL) { networkResult in
            switch networkResult {
            case .success (let imgToEmotionResponse) :
                if let response = imgToEmotionResponse as? ImgToEmotionResponse {
                    
                    print("감정 받기 성공")
                    print("Emotion: \(response.emotion)")
                    
                    UserDefaults.standard.set(response.emotion, forKey: "emotion")
                    
                    //indicator 멈추기
                    self.stopActivityIndicator()
                    self.presentMainViewController()
                    
                    //self.indicatorView.stopAnimating()
                }
                
            case .requestErr(let data):
                print("imgToEmotion request error: \(data)")
                // 요청 에러 처리
                
            case .serverErr:
                print("imgToEmotion server error")
                // 서버 에러 처리
                
            case .networkFail:
                print("imgToEmotion network error")
                // 네트워크 에러 처리
                
            case .pathErr:
                print("imgToEmotion path error")
                // 경로 에러 처리
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
