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
        
        //self.dismiss(animated: true, completion: nil)
        
        // 화면이 좌측에서 우측으로 사라지는 애니메이션 추가
        let transition = CATransition()
        transition.duration = 0.2 // 애니메이션 지속 시간 설정
        transition.type = CATransitionType.push // 푸시 애니메이션 타입 선택
        transition.subtype = CATransitionSubtype.fromLeft // 방향 설정 (좌측에서 우측으로)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        // 화면을 dismiss
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func unregisterBtnTapped(_ sender: UIButton) {
        appwithdraw()
        
        print("회원탈퇴 토큰: \(KeyChain.loadToken(forKey: "pmuaccessToken"))")
    }
    
    func appwithdraw() {
        if let savedToken = KeyChain.loadToken(forKey: "pmuaccessToken") {
            KakaoLogoutService.withdraw(auth: savedToken) { networkResult in
                switch networkResult {
                case .success:
                    print("Kakao withdraw success")
                    // 탈퇴 성공 시, UI 및 데이터 초기화 또는 필요한 작업 수행
                    KeyChain.deleteToken(forKey: "pmuaccessToken")
                    KeyChain.deleteToken(forKey: "pmurefreshToken")
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
}
