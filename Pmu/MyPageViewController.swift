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
