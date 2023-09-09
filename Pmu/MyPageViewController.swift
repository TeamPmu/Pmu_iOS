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
    @IBOutlet weak var nickNameLbl: UILabel!
    
    @IBOutlet weak var documentBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var unregisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        StackView.layer.cornerRadius = 10
        StackView.clipsToBounds = true
        
        // 프로필 이미지 로드 및 설정하는 함수
        loadProfileImage()
        
        setNickNameLabel()
        
    }
    
    // 프로필 이미지 로드 및 설정하는 함수
    func loadProfileImage() {
        // KakaoLoginService 등의 다른 코드 내에서 데이터 사용 방법
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            if let profileImgURLString = loginResponse.data.profileImageURL,
               let profileImgURL = URL(string: profileImgURLString) {
                print("프로필 이미지 URL: \(profileImgURLString)") // 디버그 출력
                // 이미지 다운로드 및 설정
                DispatchQueue.global().async { // 비동기적으로 이미지 다운로드 수행
                    if let imageData = try? Data(contentsOf: profileImgURL),
                       let profileImage = UIImage(data: imageData) {
                        DispatchQueue.main.async { // 다운로드 완료 후 메인 쓰레드에서 UI 업데이트
                            print("프로필 이미지 다운로드 및 설정 성공") // 디버그 출력
                            self.profileImg.image = profileImage
                        }
                    } else {
                        self.profileImg.image = UIImage(named: "myPageFilled")
                        self.profileImg.backgroundColor = UIColor.gray
                        print("프로필 이미지 다운로드 실패") // 디버그 출력
                    }
                }
            } else {
                self.profileImg.image = UIImage(named: "myPageFilled")
                self.profileImg.backgroundColor = UIColor.gray
                print("프로필 이미지 URL 변환 실패") // 디버그 출력
            }
        } else {
            print("로그인 응답 데이터가 없음") // 디버그 출력
        }
    }
    
    /*func loadProfileImage() {
     if let profileImageURL = KakaoDataManager.shared.getLoginResponse()?.data.profileImageURL {
     // Alamofire를 사용하여 프로필 이미지 다운로드
     AF.request(profileImageURL).responseImage { response in
     switch response.result {
     case .success(let image):
     self.profileImg.image = image
     case .failure(let error):
     print("Error downloading profile image: \(error)")
     }
     }
     }
     }*/
    
    /*func loadUsername() {
     if let username = KakaoDataManager.shared.getLoginResponse()?.data.nickname {
     nickNameLbl.text = username
     }*/
    
    
    func setNickNameLabel() {
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            let nickname = loginResponse.data.nickname
            let formattedNickname = nickname
            print("변경된 닉네임: \(formattedNickname)") // 디버그 출력
            nickNameLbl.text = formattedNickname
        } else {
            print("로그인 응답 데이터가 없음") // 디버그 출력
        }
    }
    
    
    @IBAction func documentBtnTapped(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/TeamPmu/Pmu_iOS") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func logOutBtnTapped(_ sender: UIButton) {
        /*UserApi.shared.logout{(error) in
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
         }*/
        
        /*UserApi.shared.logout { [weak self] (error) in
         if let error = error {
         print(error)
         } else {
         print("Kakao logout success")
         // 로그아웃 성공 시, UI 및 데이터 초기화
         //self?.clearUserData()
         }
         }*/
        
        // 1. 사용자의 인증 토큰을 얻어온다. (이 부분은 로그인 성공 후에 토큰을 저장하는 곳에서 이미 처리하고 있어야 합니다.)
        guard let appaccessToken = KeyChain.loadToken(forKey: "appaccessToken") else {
            // 사용자 토큰이 없으면 이미 로그아웃된 상태
            print("사용자 토큰이 없음. 이미 로그아웃되었습니다.")
            return
        }
        
        // 2. KakaoLogoutService를 사용하여 로그아웃 요청을 보낸다.
        KakaoLogoutService.signout(auth: appaccessToken) { result in
            switch result {
            case .success(let response):
                // 로그아웃 성공
                print("로그아웃 성공")
                
                // 3. 사용자 토큰을 삭제한다. (토큰을 저장하고 삭제하는 부분은 KeyChain 클래스에서 처리)
                KeyChain.deleteToken(forKey: "appaccessToken")
                
                // 4. 로그아웃 후에 필요한 UI 업데이트 또는 화면 전환을 수행한다.
                // 예를 들어, 로그아웃 후 로그인 화면으로 이동하는 등의 작업을 수행할 수 있습니다.
                
                if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? ViewController {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController, animated: true)
                }
                
            case .requestErr(let errorData):
                // 로그아웃 요청이 실패하였을 경우
                print("로그아웃 실패 - 요청 오류: \(errorData.message)")
                
            case .serverErr:
                // 서버 오류
                print("로그아웃 실패 - 서버 오류")
                
            case .networkFail:
                // 네트워크 오류
                print("로그아웃 실패 - 네트워크 오류")
            case .pathErr:
                // 경로 오류
                print("로그아웃 실패 - 경로 오류")
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
        
        /*let UnregisterVC =  UIStoryboard(name: "Main", bundle: nil)
         .instantiateViewController(withIdentifier: "UnregisterVC")
         
         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UnregisterVC, animated: true)
         }*/
        
        
        /*KakaoLogoutService.withdraw(auth: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaWF0IjoxNjkzODI4MDM0LCJleHAiOjE2OTQ0MzI4MzR9.f4L_FWiKRFJ2wnl8PfmiUKEJuShC-dsNKPmNljEKa6E") { networkResult in
            switch networkResult {
            case .success:
                print("Kakao withdraw success")
                // 탈퇴 성공 시, UI 및 데이터 초기화 또는 필요한 작업 수행
                
                // 예시: 로그아웃 또는 탈퇴 후, 다시 로그인 화면으로 이동
                if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? ViewController {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController, animated: true)
                }
                
            case .requestErr(let data):
                print("Kakao withdraw request error: \(data)")
                // 요청 에러 처리
                
            case .serverErr:
                print("Kakao withdraw server error")
                // 서버 에러 처리
                
            case .networkFail:
                print("Kakao withdraw network error")
                // 네트워크 에러 처리
                
            case .pathErr:
                print("Kakao withdraw network error")
                // 경로 에러 처리
            }
        } */
    
        appwithdraw()
        
        print("회원탈퇴 토큰: \(KeyChain.loadToken(forKey: "appaccessToken"))")
        
        // 액세스 토큰을 갱신하고 갱신 성공 시 탈퇴 요청 보내기
        //refreshAccessTokenAndWithdraw()
    }
    
    // 액세스 토큰을 갱신하고 탈퇴 요청을 보내는 함수
    func refreshAccessTokenAndWithdraw() {
        AuthApi.shared.refreshToken { (oauthToken, error) in
            if let error = error {
                print("액세스 토큰 갱신 실패: \(error)")
                // 에러 메시지를 사용자에게 표시하거나 다른 처리를 수행할 수 있습니다.
            } else {
                // 액세스 토큰 갱신 성공
                if let savedToken = KeyChain.loadToken(forKey: "accessToken") {
                    self.withdraw(with: savedToken)
                } else {
                    // 로그인 정보가 없는 경우 처리
                }
            }
        }
    }
    
    func appwithdraw() {
        if let savedToken = KeyChain.loadToken(forKey: "appaccessToken") {
            KakaoLogoutService.withdraw(auth: savedToken) { networkResult in
                switch networkResult {
                case .success:
                    print("Kakao withdraw success")
                    // 탈퇴 성공 시, UI 및 데이터 초기화 또는 필요한 작업 수행
                    KeyChain.deleteToken(forKey: "appaccessToken")
                    KeyChain.deleteToken(forKey: "accessToken")
                    // 예시: 로그아웃 또는 탈퇴 후, 다시 로그인 화면으로 이동
                    if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? ViewController {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController, animated: true)
                    }
                    
                case .requestErr(let data):
                    print("Kakao withdraw request error: \(data)")
                    // 요청 에러 처리
                    
                case .serverErr:
                    print("Kakao withdraw server error")
                    // 서버 에러 처리
                    
                case .networkFail:
                    print("Kakao withdraw network error")
                    // 네트워크 에러 처리
                    
                case .pathErr:
                    print("Kakao withdraw network error")
                    // 경로 에러 처리
                }
            }
        } else {
            // 저장된 액세스 토큰이 없는 경우 처리
            print("저장된 액세스 토큰이 없음")
            // 에러 메시지를 사용자에게 표시하거나 다른 처리를 수행할 수 있습니다.
        }
    }
    
    // 탈퇴 요청 보내는 함수
    func withdraw(with token: String) {
        KakaoLogoutService.withdraw(auth: token) { networkResult in
            switch networkResult {
            case .success:
                print("Kakao withdraw success")
                // 탈퇴 성공 시, UI 및 데이터 초기화 또는 필요한 작업 수행
                
                // 예시: 로그아웃 또는 탈퇴 후, 다시 로그인 화면으로 이동
                if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? ViewController {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController, animated: true)
                }
                
            case .requestErr(let data):
                print("Kakao withdraw request error: \(data)")
                // 요청 에러 처리
                
            case .serverErr:
                print("Kakao withdraw server error")
                // 서버 에러 처리
                
            case .networkFail:
                print("Kakao withdraw network error")
                // 네트워크 에러 처리
                
            case .pathErr:
                print("Kakao withdraw network error")
                // 경로 에러 처리
            }
        }
    }
    
    // 로그아웃 또는 탈퇴 성공 시 호출되는 함수
    /*private func clearUserData() {
        // UI 초기화 (프로필 이미지, 닉네임 등)
        self.profileImg.image = UIImage(named: "myPageFilled")
        self.nickNameLbl.text = ""
        
        // 기타 데이터 초기화 또는 필요한 작업 수행
        // ...
        
        // 예시: 로그아웃 또는 탈퇴 후, 다시 로그인 화면으로 이동
        if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController, animated: true)
        }
    }*/
}

