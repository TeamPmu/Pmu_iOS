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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 스토리보드 ID로 두 번째 뷰 컨트롤러 인스턴스화
        if let MainVC = storyboard.instantiateViewController(withIdentifier: "Main") as? BaseTableBarController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = MainVC
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
    

}
