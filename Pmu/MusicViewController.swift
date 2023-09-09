//
//  MusicViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit
import Alamofire

class MusicViewController: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var textCountLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    
    let borderGray = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        txtView.delegate = self
        
        txtView.layer.cornerRadius = 10
        txtView.clipsToBounds = true
        
        //처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 만들어주기
        txtView.text = "프로필 사진 찍을 때 어떤 기분이셨나요?\n알려주세요! (최대 150자)"
        txtView.textColor = UIColor.lightGray
        
        //텍스트뷰가 구분되게끔 테두리를 주도록 하겠습니다.
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = borderGray.cgColor
        
        
        // UITextView의 delegate를 설정
        txtView.delegate = self
        
        
        // 프로필 이미지 초기화
        //self.profileImg.image = UIImage(named: "myPageFilled")
        //self.profileImg.backgroundColor = UIColor.gray
        
        // 프로필 이미지 로드 및 설정 호출
        loadProfileImage()
        
        // Set the nickname label
        setNickNameLabel()
        //loadUsername()
        
        // 노티피케이션 수신 등록
        NotificationCenter.default.addObserver(self, selector: #selector(clearTextView(_:)), name: NSNotification.Name("clearTextView"), object: nil)
    }
    
    // 'clearTextView' 노티피케이션 수신 시 호출되는 메서드
    @objc func clearTextView(_ notification: Notification) {
        // 텍스트 뷰 초기화 작업
        txtView.text = ""
        
        //처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 만들어주기
        txtView.text = "프로필 사진 찍을 때 어떤 기분이셨나요?\n알려주세요! (최대 150자)"
        txtView.textColor = UIColor.lightGray
    }
    
    /*
    @IBAction func musicBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 스토리보드 ID로 두 번째 뷰 컨트롤러 인스턴스화
        if let MusicRecoVC = storyboard.instantiateViewController(withIdentifier: "MusicReco") as? MusicRecommendViewController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = MusicRecoVC
            }
        }
    }
    */
    
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
                        DispatchQueue.main.async {
                            self.profileImg.image = UIImage(named: "myPageFilled")
                            self.profileImg.backgroundColor = UIColor.gray
                            print("프로필 이미지 다운로드 실패") // 디버그 출력
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImg.image = UIImage(named: "myPageFilled")
                    self.profileImg.backgroundColor = UIColor.gray
                    print("프로필 이미지 URL 변환 실패") // 디버그 출력
                }
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
            let formattedNickname = "\(nickname) 님을 위한"
            print("변경된 닉네임: \(formattedNickname)") // 디버그 출력
            nickNameLbl.text = formattedNickname
        } else {
            print("로그인 응답 데이터가 없음") // 디버그 출력
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtView.resignFirstResponder()
    }
    
}

extension MusicViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtView.text.isEmpty {
            txtView.text =  "플레이스홀더입니다"
            txtView.textColor = UIColor.lightGray
        }

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtView.textColor == UIColor.lightGray {
            txtView.text = nil
            txtView.textColor = UIColor.black
        }
    }
    
    // UITextView의 텍스트가 변경될 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        // 현재 텍스트 뷰의 텍스트 길이를 가져와서 라벨에 표시
        let text = textView.text
        let characterCount = text?.count ?? 0
        textCountLbl.text = "\(characterCount)"
        
        // 최대 글자 수를 초과하면 입력 방지
        if characterCount > 150 {
            textView.deleteBackward()
        }
    }
}
