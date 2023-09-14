//
//  UnregisterViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/05.
//

import UIKit

class UnregisterViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var unregisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        /*if let UnregisterVC = storyboard.instantiateViewController(withIdentifier: "MyPageVC") as? MyPageViewController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = UnregisterVC
            }
        }*/
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1 // 두 번째 탭 선택
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: true) // 선택된 탭의 루트 뷰 컨트롤러로 이동
            }
        }
        
        /*let UnregisterVC = UIStoryboard(name: "MyPageVC", bundle: nil)
            .instantiateViewController(withIdentifier: "UnregisterViewController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(UnregisterVC, animated: true)*/
    }
    
    @IBAction func unregisterBtnTapped(_ sender: UIButton) {
        appwithdraw()
        
        print("회원탈퇴 토큰: \(KeyChain.loadToken(forKey: "appaccessToken"))")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
