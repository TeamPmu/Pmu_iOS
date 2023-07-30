//
//  MusicViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/28.
//

import Foundation
import UIKit

class MusicViewController: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    
    let borderGray = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profileImg.layer.cornerRadius = 32
        profileImg.clipsToBounds = true
        
        txtView.delegate = self
        
        txtView.layer.cornerRadius = 10
        txtView.clipsToBounds = true
               
        //처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 만들어주기
        txtView.text = "프로필 사진 찍을 때 어떤 기분이셨나요?\n알려주세요!(최대 150자)"
        txtView.textColor = UIColor.lightGray
               
               
        //텍스트뷰가 구분되게끔 테두리를 주도록 하겠습니다.
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = borderGray.cgColor
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
}