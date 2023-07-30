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
    
    let checkBackGround = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
    //let checkedBackGround = UIColor(red: 245, green: 245, blue: 245, alpha: 1)


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileImg.layer.cornerRadius = profileImg.frame.width / 2
        profileImg.clipsToBounds = true
        
        nameLbl.layer.cornerRadius = 12
        nameLbl.clipsToBounds = true
        
        //checkBtn.backgroundColor = checkBackGround
        
        // 버튼이 눌려진 상태일 때의 이미지와 텍스트 설정
        //checkBtn.setTitle("이용약관에 동의합니다.", for: .highlighted)
        //checkBtn.setTitleColor(UIColor.white, for: .highlighted)
        //checkBtn.setImage(UIImage(named: "checkedmark"), for: .highlighted)
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
        
        if checkBtn.backgroundColor == checkBackGround {
            checkBtn.backgroundColor = UIColor.black
            checkBtn.setTitle("이용약관에 동의합니다.", for: .normal)
            checkBtn.setTitleColor(UIColor.white, for: .normal)
            checkBtn.setImage(UIImage(named: "checkedmark"), for: .normal)
            }
        else {
            checkBtn.backgroundColor = checkBackGround
            checkBtn.setTitle("이용약관에 동의합니다.", for: .normal)
            checkBtn.setTitleColor(UIColor.black, for: .normal)
            checkBtn.setImage(UIImage(named: "checkmark"), for: .normal)
            }
    }
    

}
