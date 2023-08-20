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
        
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
        
        /*if checkBtn.backgroundColor == checkBackGround {
            checkBtn.backgroundColor = UIColor.black
            checkBtn.setTitle("이용약관에 동의합니다.", for: .normal)
            checkBtn.setTitleColor(UIColor.white, for: .normal)
            checkBtn.setImage(UIImage(named: "checkedmark"), for: .normal)
            
            // 버튼이 눌려진 상태일 때의 이미지와 텍스트 설정
            checkBtn.setTitle("이용약관에 동의합니다.", for: .highlighted)
            checkBtn.setTitleColor(UIColor.white, for: .highlighted)
            checkBtn.setImage(UIImage(named: "checkedmark"), for: .highlighted)
            }
         
        else {
            checkBtn.backgroundColor = checkBackGround
            checkBtn.setTitle("이용약관에 동의합니다.", for: .normal)
            checkBtn.setTitleColor(UIColor.black, for: .normal)
            checkBtn.setImage(UIImage(named: "checkmark"), for: .normal)
            
            // 버튼이 눌려진 상태일 때의 이미지와 텍스트 설정
            checkBtn.setTitle("이용약관에 동의합니다.", for: .highlighted)
            checkBtn.setTitleColor(UIColor.black, for: .highlighted)
            checkBtn.setImage(UIImage(named: "checkmark"), for: .highlighted)
            } */
        
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
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 스토리보드 ID로 두 번째 뷰 컨트롤러 인스턴스화
        /* if let MainVC = storyboard.instantiateViewController(withIdentifier: "Main") as? BaseTableBarController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = MainVC
            }
        }*/
        
       /* if let inputText = nameTextField.text {
            // inputText에 UITextField에서 입력한 문자열이 저장됩니다.
            print("입력값: \(inputText)")
        }
        
        if let savedToken = UserDefaults.standard.string(forKey: "token") {
            if let nickname = nameTextField.text {
                signUp(with: savedToken, nickname: nickname)
                print(nickname)
            }
        } else {
            // 토큰이 없는 경우 처리
            print("처리 불가")
        }
        
        let MainVC =  UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Main")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainVC, animated: true)*/
        
        if let savedToken = UserDefaults.standard.string(forKey: "token"), let nickname = nameTextField.text {
            // 토큰이 있는 경우 회원 가입 시도
            signUp(with: savedToken, nickname: nickname)
            
            print(savedToken)
            // 회원 가입이 성공하면 현재 화면을 종료하고 메인 화면으로 이동
            /*self.dismiss(animated: true) {
                let MainVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "Main")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                    .changeRootViewController(MainVC, animated: true)
            }*/
            
            print(nickname)
        } else {
            // 토큰이 없는 경우 처리
            print("토큰이 없어 회원 가입을 진행할 수 없습니다.")
        }
    }
    
 /*   func signUp(with token: String, nickname: String) {
        // 이 함수 내에서 KakaoLoginService의 signUp 메서드를 호출하면서 토큰과 닉네임을 전달합니다.
        KakaoLoginService.signUp(auth: token, nickname: nickname) { networkResult in
            switch networkResult {
            case .success(_):
                // 가입 성공 시 처리
                print("가입 성공")
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    } */
    
    func signUp(with token: String, nickname: String) {
        // 이 함수 내에서 KakaoLoginService의 signUp 메서드를 호출하면서 토큰과 닉네임을 전달합니다.
        KakaoLoginService.signUp(auth: token, nickname: nickname) { [weak self] networkResult in
            guard let self = self else { return }
            
            switch networkResult {
            case .success(_):
                // 가입 성공 시 처리
                print("가입 성공")
                
                // 회원 가입이 성공하면 현재 화면을 종료하고 메인 화면으로 이동
                /*self.dismiss(animated: true) {
                    let MainVC = UIStoryboard(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "Main")
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                        .changeRootViewController(MainVC, animated: true)
                }*/
                
                // 회원 정보가 있는 경우
                let MainVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "Main")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainVC, animated: true)
                
            case .requestErr(_):
                print("sign up requestErr")
                // 에러 처리 로직 추가
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
