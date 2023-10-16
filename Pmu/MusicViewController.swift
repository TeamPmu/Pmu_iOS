//
//  MusicViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit
import Alamofire
import AWSLambda

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
    //프로필 URL 전달
    func invokeLambdaEmotionFunction(profileURL: String) {
        let lambdaInvoker = AWSLambdaInvoker.default()

        let functionName = "YourLambdaFunctionName" // 호출할 Lambda 함수 이름
        let requestPayload = ["URL": profileURL] // Lambda 함수로 전달할 데이터

        lambdaInvoker.invokeFunction(functionName, jsonObject: requestPayload)
            .continueWith { (task) -> Any? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                if let result = task.result as? [String: Any] {
                    print("Lambda Result: \(result)")
                    UserDefaults.standard.set(result, forKey: "emotion")
                }
                return nil
            }
    }
    
    //감정, 텍스트 전달
    func invokeLambdaMusicRecommandFunction(emotion: String, text: String) {
        let lambdaInvoker = AWSLambdaInvoker.default()
        
        let functionName = "YourLambdaFunctionName" // 호출할 Lambda 함수 이름
        let requestPayload = ["emotion": emotion, "text": text] // Lambda 함수로 전달할 데이터

        lambdaInvoker.invokeFunction(functionName, jsonObject: requestPayload)
            .continueWith { (task) -> Any? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                if let result = task.result as? [String: Any] {
                    print("Lambda Result: \(result)")
                }
                return nil
            }
    }
    */
    
    @IBAction func musicBtnTapped(_ sender: UIButton) {
        
        // 텍스트 뷰에 입력된 텍스트 가져오기
        guard let textToSave = txtView.text else {
            return
        }
        
        // 가져온 텍스트를 UserDefaults에 저장
        UserDefaults.standard.set(textToSave, forKey: "savedText")
        
        // 저장 완료 메시지 또는 다른 작업 수행
        print("Text saved successfully!")
        
        if let savedText = UserDefaults.standard.string(forKey: "savedText") {
            // 가져온 문자열을 출력
            print("Saved Text: \(savedText)")
        } else {
            // "savedText" 키에 대한 값이 없는 경우 처리
            print("No saved text found.")
        }
        
        /*
        // UserDefaults에서 "emotion"과 "savedText" 키에 해당하는 값을 가져오기
        if let emotion = UserDefaults.standard.string(forKey: "emotion"),
           let savedText = UserDefaults.standard.string(forKey: "savedText") {
            // 가져온 emotion 값을 이용하여 Lambda 함수 호출
            self.invokeLambdaMusicRecommandFunction(emotion: emotion, text: savedText)
        } else {
            // "emotion" 또는 "savedText" 키에 대한 값이 없는 경우 처리
            print("No emotion or saved text found in UserDefaults")
        }
        */
    }
    
    // 프로필 이미지 로드 및 설정하는 함수
    func loadProfileImage() {
        // KakaoLoginService 등의 다른 코드 내에서 데이터 사용 방법
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            if let profileImgURLString = loginResponse.data!.profileImageURL,
               let profileImgURL = URL(string: profileImgURLString) {
                print("프로필 이미지 URL: \(profileImgURLString)") // 디버그 출력
                // 이미지 다운로드 및 설정
                DispatchQueue.global().async { // 비동기적으로 이미지 다운로드 수행
                    if let imageData = try? Data(contentsOf: profileImgURL),
                       let profileImage = UIImage(data: imageData) {
                        DispatchQueue.main.async { // 다운로드 완료 후 메인 쓰레드에서 UI 업데이트
                            print("프로필 이미지 다운로드 및 설정 성공") // 디버그 출력
                            self.profileImg.image = profileImage
                            //self.invokeLambdaEmotionFunction(profileURL: profileImgURLString)
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
