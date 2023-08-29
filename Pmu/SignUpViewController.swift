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
    
    let checkBackGround = UIColor(red: 250, green: 250, blue: 250, alpha: 1)
    //let checkedBackGround = UIColor(red: 245, green: 245, blue: 245, alpha: 1)

    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        profileImg.layer.cornerRadius = profileImg.frame.width / 2
        profileImg.clipsToBounds = true
        
        nameLbl.layer.cornerRadius = 12
        nameLbl.clipsToBounds = true
        
        // 초기에 버튼을 비활성화
        signUpBtn.isEnabled = false
        
        // 프로필 이미지 로드 및 설정 호출
        loadProfileImage()
        
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
       
    @IBAction func checkBtnTapped(_ sender: UIButton) {

        if num % 2 == 0 {
            checkBtn.setImage(UIImage(named: "agreedbutton"), for: .normal)
            signUpBtn.setImage(UIImage(named: "signUpYellow"), for: .normal)
            signUpBtn.isEnabled = true
            num+=1
            
        } else {
            checkBtn.setImage(UIImage(named: "agreebutton"), for: .normal)
            signUpBtn.setImage(UIImage(named: "signUpGray"), for: .normal)
            signUpBtn.isEnabled = false
            num+=1
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if let savedToken = UserDefaults.standard.string(forKey: "token"), let nickname = nameTextField.text {
                    // 토큰이 있는 경우 회원 가입 시도
                    signUp(with: savedToken, nickname: nickname)
                    
                    print(savedToken)
                    print(nickname)
            
            
                } else {
                    // 토큰이 없는 경우 처리
                    print("토큰이 없어 회원 가입을 진행할 수 없습니다.")
                }
    }
    
    func signUp(with token: String, nickname: String) {
        // 이 함수 내에서 KakaoLoginService의 signUp 메서드를 호출하면서 토큰과 닉네임을 전달합니다.
        KakaoLoginService.signUp(auth: token, nickname: nickname) { [weak self] networkResult in
            guard let self = self else { return }
            
            switch networkResult {
            case .success(let kakaoResponse):
                // 가입 성공 시 처리
                print("가입 성공")
                
                // Response 값 출력
                print("Status: \(kakaoResponse.status)")
                print("Message: \(kakaoResponse.message)")
                print("AccessToken: \(kakaoResponse.data.accessToken)")
                print("RefreshToken: \(kakaoResponse.data.refreshToken)")
                print("UserID: \(kakaoResponse.data.userID)")
                
                // 회원 가입이 성공하면 현재 화면을 종료하고 메인 화면으로 이동
                self.dismiss(animated: true) {
                    let MainVC = UIStoryboard(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "Main")
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                        .changeRootViewController(MainVC, animated: true)
                }
                
            case .requestErr(let kakaoResponse):
                print("sign up requestErr")
                // 에러 처리 로직 추가
                print("Status: \(kakaoResponse.status)")
                print("Message: \(kakaoResponse.message)")
                
            case .pathErr:
                print("sign up pathErr")
                // 에러 처리 로직 추가
            case .serverErr:
                print("sign up serverErr")
                // 에러 처리 로직 추가
            case .networkFail:
                print("sign up networkFail")
                // 에러 처리 로직 추가
            }
        }
    }
    
    @IBAction func urlBtnTapped(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/TeamPmu/Pmu_iOS") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    /*
    @IBAction func backBtnTapped(_ sender: UIButton) {
        guard let logoVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController else { return }
        signUpVC.modalTransitionStyle = .coverVertical
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }
    */
}

// UITextFieldDelegate method to dismiss keyboard when Return key is pressed
extension SignUpViewController : UITextFieldDelegate{
    
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
  }
}
