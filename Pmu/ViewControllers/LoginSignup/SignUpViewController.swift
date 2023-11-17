//
//  SignUpViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit

class SignUpViewController: UIViewController {
    
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
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var urlBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorBGView.isHidden = true
        indicatorLbl.isHidden = true
        
        nameLbl.layer.cornerRadius = 12
        nameLbl.clipsToBounds = true
        
        // 초기에 버튼을 비활성화
        signUpBtn.isEnabled = false
        
        // Add a tap gesture recognizer to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Set the delegate of the text field
        self.nameTextField.delegate = self
    }
    
    func stopActivityIndicator() {
        indicatorBGView.isHidden = true
        indicatorLbl.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    @objc func dismissKeyboard() {
        // Resign first responder status to dismiss the keyboard
        self.nameTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
        if signUpBtn.isEnabled == false, let text = nameTextField.text, !text.isEmpty {
            checkBtn.setImage(UIImage(named: "agreedbutton"), for: .normal)
            signUpBtn.setImage(UIImage(named: "signUpYellow"), for: .normal)
            signUpBtn.isEnabled = true
            
        } else {
            checkBtn.setImage(UIImage(named: "agreebutton"), for: .normal)
            signUpBtn.setImage(UIImage(named: "signUpGray"), for: .normal)
            signUpBtn.isEnabled = false
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if let savedToken = KeyChain.loadToken(forKey: "accessToken") /*UserDefaults.standard.string(forKey: "token")*/, let nickname = nameTextField.text {
            // 토큰이 있는 경우 회원 가입 시도
            self.signUp(with: savedToken, nickname: nickname)
            
            //print(savedToken)
            //print(nickname)
            
        } else {
            // 토큰이 없는 경우 처리
            print("토큰이 없어 회원 가입을 진행할 수 없습니다.")
        }
    }
    
    func signUp(with token: String, nickname: String) {
        // 이 함수 내에서 KakaoLoginService의 signUp 메서드를 호출하면서 토큰과 닉네임을 전달합니다.
        KakaoLoginService.signUp(auth: token, nickname: nickname) { networkResult in
            switch networkResult {
            case .success(let kakaoResponse):
                if let response = kakaoResponse as? KakaoLoginResponse {
                    let signUpData = response.data
                    
                    if !signUpData!.accessToken.isEmpty {
                        DispatchQueue.main.async {
                            print("회원가입 성공")
                            print("signUp AccessToken: \(signUpData!.accessToken)")
                            print("signUp RefreshToken: \(signUpData!.refreshToken)")
                            print("signUp UserID: \(signUpData!.userID)")
                            print("signUp ProfileImageURL: \(signUpData!.profileImageURL)")
                            print("signUp Nickname: \(signUpData!.nickname)")
                            
                            // AccessToken을 Keychain에 저장
                            KeyChain.saveToken(signUpData!.accessToken, forKey: "pmuaccessToken")
                            KeyChain.saveToken(signUpData!.refreshToken, forKey: "pmurefreshToken")
                            
                            if let profileImgURLString = signUpData!.profileImageURL {
                                self.view.addSubview(self.activityIndicator)
                                self.imgToEmotion(profileURL: profileImgURLString)
                                //indicator start
                            }
                            
                            //self.presentMainViewController()
                            //self.presentEmotionIndicatorViewController()
                        }
                    } else {
                        print("AccessToken is empty")
                        DispatchQueue.main.async {
                            self.showAlert(title: "signUp Error", message: "An error occurred while processing the response.")
                        }
                    }
                } else {
                    print("Response parsing error")
                    DispatchQueue.main.async {
                        self.showAlert(title: "signUp Error", message: "An error occurred while processing the response.")
                    }
                }
            case .requestErr(let errorData):
                print("Request Error:", errorData)
                DispatchQueue.main.async {
                    self.showAlert(title: "signUp Request Error", message: "Please try again.")
                }
            case .pathErr, .serverErr, .networkFail:
                print("Network Error")
                DispatchQueue.main.async {
                    self.showAlert(title: "signUp Network Error", message: "Please try again later.")
                }
            }
        }
    }
    
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
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func urlBtnTapped(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/TeamPmu/Pmu_iOS") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        KeyChain.deleteToken(forKey: "pmuaccessToken")
        KeyChain.deleteToken(forKey: "pmurefreshToken")
        KeyChain.deleteToken(forKey: "accessToken")

        let loginVC =  UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginVC")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC, animated: true)
    }
}

// UITextFieldDelegate method to dismiss keyboard when Return key is pressed
extension SignUpViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
