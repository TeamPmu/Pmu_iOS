//
//  SignUpViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var urlBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.cornerRadius = profileImg.frame.width / 2
        profileImg.clipsToBounds = true
        
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
                            
                            //self.presentMainViewController()
                            self.presentEmotionIndicatorViewController()
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
    
    func presentMainViewController() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Main")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(mainVC, animated: true)
    }
    
    func presentEmotionIndicatorViewController() {
        let emotionIndicatorVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "EmotionIndicatorView")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(emotionIndicatorVC, animated: true)
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
