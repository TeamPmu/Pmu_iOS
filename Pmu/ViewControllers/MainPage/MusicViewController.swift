//
//  MusicViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit
import Alamofire
//import AWSLambda

class MusicViewController: UIViewController {
    
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
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var textCountLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    
    let borderGray = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorBGView.isHidden = true
        indicatorLbl.isHidden = true

        // Do any additional setup after loading the view.
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
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
        
        // 프로필 이미지 로드 및 설정 호출
        //loadProfileImage()
        self.profileImg.image = UIImage(named: "exProfileImg.jpg")

        
        // Set the nickname label
        setNickNameLabel()
        //loadUsername()
        
        // 노티피케이션 수신 등록
        NotificationCenter.default.addObserver(self, selector: #selector(clearTextView(_:)), name: NSNotification.Name("clearTextView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textCountLbl.text = "0"

        // 처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 만들어주기
        txtView.text = "프로필 사진 찍을 때 어떤 기분이셨나요?\n알려주세요! (최대 150자)"
        txtView.textColor = UIColor.lightGray
        
        // 노티피케이션 수신 등록
        NotificationCenter.default.addObserver(self, selector: #selector(clearTextView(_:)), name: NSNotification.Name("clearTextView"), object: nil)
    }
    
    func stopActivityIndicator() {
        indicatorBGView.isHidden = true
        indicatorLbl.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    // 'clearTextView' 노티피케이션 수신 시 호출되는 메서드
    @objc func clearTextView(_ notification: Notification) {
        //처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 만들어주기
        txtView.text = "프로필 사진 찍을 때 어떤 기분이셨나요?\n알려주세요! (최대 150자)"
        txtView.textColor = UIColor.lightGray
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
                    
                    self.stopActivityIndicator()
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
    
    //APIgateway 감정, 텍스트 전달
    func emotionToMusic(emotion: String, text: String){
        EmotionToMusicService.emotionToMusic(emotion: emotion, text: text) { networkResult in
            switch networkResult {
            case .success (let emotionToMusicResponse) :
                if let response = emotionToMusicResponse as? EmotionToMusicResponse {
                    
                    print("추천음악 받기 성공")
                    
                    // Song 배열 출력
                    for song in response.Song {
                        print("Song: \(song)")
                    }
                    
                    // Singer 배열 출력
                    for singer in response.Singer {
                        print("Singer: \(singer)")
                    }
                    
                    // cover 배열 출력
                    for cover in response.cover {
                        print("Cover: \(cover)")
                    }
                    
                    // youtube 배열 출력
                    for youtube in response.youtube {
                        print("YouTube: \(youtube)")
                    }
                    
                    self.stopActivityIndicator()
                    self.moveToMusicRecommandPage()
                }
                
            case .requestErr(let data):
                print("emotionToMusic request error: \(data)")
                // 요청 에러 처리
                
            case .serverErr:
                print("emotionToMusic server error")
                // 서버 에러 처리
                
            case .networkFail:
                print("emotionToMusic network error")
                // 네트워크 에러 처리
                
            case .pathErr:
                print("emotionToMusic path error")
                // 경로 에러 처리
            }
        }
    }
    
    func moveToMusicRecommandPage() {
        guard let MusicRecoVC = self.storyboard?.instantiateViewController(withIdentifier: "MusicReco") as? MusicRecommendViewController else { return }
        MusicRecoVC.modalTransitionStyle = .coverVertical
        MusicRecoVC.modalPresentationStyle = .fullScreen
        self.present(MusicRecoVC, animated: true, completion: nil)
    }
    
    @IBAction func musicBtnTapped(_ sender: UIButton) {
        // 텍스트 뷰에 입력된 텍스트 가져오기
        guard let textToSave = txtView.text else {
            return
        }
        
        // 가져온 텍스트를 UserDefaults에 저장
        /*UserDefaults.standard.set(textToSave, forKey: "savedText")
        
        // 저장 완료 메시지 또는 다른 작업 수행
        print("Text saved successfully!")
        
        if let savedText = UserDefaults.standard.string(forKey: "savedText") {
            // 가져온 문자열을 출력
            print("Saved Text: \(savedText)")
        } else {
            // "savedText" 키에 대한 값이 없는 경우 처리
            print("No saved text found.")
        }*/
        
        if let emotion = UserDefaults.standard.string(forKey: "emotion"),
           txtView.text != "" {
            
            self.view.addSubview(self.activityIndicator)
            // 가져온 emotion 값을 이용하여 Lambda 함수 호출
            print(txtView.text)
            emotionToMusic(emotion: emotion, text: txtView.text)
            
        } else {
            // "emotion" 또는 "savedText" 키에 대한 값이 없는 경우 처리
            print("No emotion or saved text found in UserDefaults")
        }
        
        /*if let emotion = UserDefaults.standard.string(forKey: "emotion"),
           let savedText = UserDefaults.standard.string(forKey: "savedText") {
            
            self.view.addSubview(self.activityIndicator)
            // 가져온 emotion 값을 이용하여 Lambda 함수 호출
            print(txtView.text)
            emotionToMusic(emotion: emotion, text: txtView.text)
            
        } else {
            // "emotion" 또는 "savedText" 키에 대한 값이 없는 경우 처리
            print("No emotion or saved text found in UserDefaults")
        }*/
    }
    
    // 프로필 이미지 로드 및 설정하는 함수
    func loadProfileImage() {
        // KakaoLoginService 등의 다른 코드 내에서 데이터 사용 방법
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            if let profileImgURLString = loginResponse.data!.profileImageURL,
               let profileImgURL = URL(string: profileImgURLString)  {
                print("프로필 이미지 URL: \(profileImgURLString)") // 디버그 출력
                // 이미지 다운로드 및 설정
                DispatchQueue.global().async { // 비동기적으로 이미지 다운로드 수행
                    if let imageData = try? Data(contentsOf: profileImgURL),
                       let profileImage = UIImage(data: imageData) {
                        DispatchQueue.main.async { // 다운로드 완료 후 메인 쓰레드에서 UI 업데이트
                            print("프로필 이미지 다운로드 및 설정 성공") // 디버그 출력
                            self.profileImg.image = profileImage
                            
                            print("프사url형식: \(profileImgURLString)")
                            //프사url 전달
                            //self.invokeLambdaEmotionFunction(profileURL: profileImgURLString)
                            //self.imgToEmotion(profileURL: profileImgURLString)
                            
                            //self.imgToEmotion(profileURL: "https://t1.daumcdn.net/news/202301/05/iMBC/20230105175435888xbsp.jpg")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.profileImg.image = UIImage(named: "dress")
                            self.profileImg.backgroundColor = UIColor.gray
                            print("프로필 이미지 다운로드 실패") // 디버그 출력
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImg.image = UIImage(named: "dress")
                    self.profileImg.backgroundColor = UIColor.gray
                    print("프로필 이미지 URL 변환 실패") // 디버그 출력
                }
            }
        } else {
            print("로그인 응답 데이터가 없음") // 디버그 출력
        }
    }
    
    func setNickNameLabel() {
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            let nickname = loginResponse.data!.nickname
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
            txtView.text =  "프로필 사진 찍을 때 어떤 기분이셨나요?\n알려주세요! (최대 150자)"
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
