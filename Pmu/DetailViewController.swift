//
//  DetailViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/29.
//

import UIKit
import MarqueeLabel

// 삭제 요청을 받을 프로토콜 정의
protocol DetailViewControllerDelegate: AnyObject {
    func deleteItem(atIndex index: Int)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var youtubeBtn: UIButton!
    
    @IBOutlet weak var musicAlbumImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var bgMusicAlbumImg: UIImageView!
    
    var isHeartSelected = true
    var albumImg: UIImage?
    var titleText: String?
    var artistText: String?
    var musicURL: String = ""
    
    weak var delegate: DetailViewControllerDelegate?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        musicAlbumImg.image = albumImg
        bgMusicAlbumImg.image = albumImg
        titleLbl.text = titleText
        artistLbl.text = artistText
        
        musicAlbumImg.layer.cornerRadius = 10
        
        // 초기 상태에서는 heartYellow 이미지를 사용
        setHeartButtonImage()
    }
    
    @IBAction func heartBtnTapped(_ sender: UIButton) {
        // 버튼을 누를 때마다 isHeartSelected 상태를 토글
        isHeartSelected.toggle()
        
        // 상태에 따라 이미지 설정
        setHeartButtonImage()
    }
    
    func setHeartButtonImage() {
        if isHeartSelected {
            heartBtn.setImage(UIImage(named: "heartYellow"), for: .normal)
        } else {
            heartBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
        
    }
    
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
        // 추가: isHeartSelected가 false인 경우 삭제 요청을 보내기
        if !isHeartSelected, let selectedIndex = selectedIndex {
            delegate?.deleteItem(atIndex: selectedIndex)
        }
        print(isHeartSelected)
        print("인덱스", selectedIndex)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func youtubeBtnTapped(_ sender: UIButton) {
        if let url = URL(string: musicURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
