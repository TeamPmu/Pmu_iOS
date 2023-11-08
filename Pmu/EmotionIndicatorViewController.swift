//
//  EmotionIndicatorViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/07.
//

import UIKit
import Alamofire

class EmotionIndicatorViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.bringSubviewToFront(self.indicatorView)
        self.indicatorView.startAnimating()
        
        loadProfileImage()
        
        // Do any additional setup after loading the view.
    }
    
    // 프로필 이미지 로드 및 설정하는 함수
    func loadProfileImage() {
        // KakaoLoginService 등의 다른 코드 내에서 데이터 사용 방법
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            if let profileImgURLString = loginResponse.data!.profileImageURL,
               let profileImgURL = URL(string: profileImgURLString)  {
                print("프로필 이미지 URL: \(profileImgURLString)") // 디버그 출력
                // 이미지 다운로드 및 설정
                self.imgToEmotion(profileURL: profileImgURLString)
                /* DispatchQueue.global().async { // 비동기적으로 이미지 다운로드 수행
                    if let imageData = try? Data(contentsOf: profileImgURL),
                       let profileImage = UIImage(data: imageData) {
                        DispatchQueue.main.async { // 다운로드 완료 후 메인 쓰레드에서 UI 업데이트
                            print("프로필 이미지 다운로드 및 설정 성공") // 디버그 출력
                            self.profileImg.image = profileImage
                            
                            print("프사url형식: \(profileImgURLString)")
                            //프사url 전달
                            //self.invokeLambdaEmotionFunction(profileURL: profileImgURLString)
                            self.imgToEmotion(profileURL: profileImgURLString)
                            
                            //self.imgToEmotion(profileURL: "https://t1.daumcdn.net/news/202301/05/iMBC/20230105175435888xbsp.jpg")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.profileImg.image = UIImage(named: "dress")
                            self.profileImg.backgroundColor = UIColor.gray
                            print("프로필 이미지 다운로드 실패") // 디버그 출력
                        }
                    }
                } */
            } else {
                DispatchQueue.main.async {
                    //self.profileImg.image = UIImage(named: "dress")
                    //self.profileImg.backgroundColor = UIColor.gray
                    print("프로필 이미지 URL 변환 실패") // 디버그 출력
                }
            }
        } else {
            print("로그인 응답 데이터가 없음") // 디버그 출력
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
                    
                    self.indicatorView.stopAnimating()
                    
                    self.presentMainViewController()
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
    
    func presentMainViewController() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Main")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(mainVC, animated: true)
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
