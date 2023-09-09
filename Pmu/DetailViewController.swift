//
//  DetailViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/29.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var youtubeBtn: UIButton!
    
    @IBOutlet weak var musicAlbumImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var bgMusicAlbumImg: UIImageView!
    
    var num = 1
    var albumImg: UIImage?
    var titleText: String?
    var artistText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        musicAlbumImg.image = albumImg
        bgMusicAlbumImg.image = albumImg
        titleLbl.text = titleText
        artistLbl.text = artistText
        
        musicAlbumImg.layer.cornerRadius = 10
        
        heartBtn.setImage(UIImage(named: "heartYellow"), for: .normal)
    }
    
    @IBAction func heartBtnTapped(_ sender: UIButton) {
        if num % 2 == 0 {
            heartBtn.setImage(UIImage(named: "heartYellow"), for: .normal)
            num+=1
            
        } else {
            heartBtn.setImage(UIImage(named: "heart"), for: .normal)
            num+=1
        }
    }
    
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
        
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 스토리보드 ID로 두 번째 뷰 컨트롤러 인스턴스화
        if let MusicVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? BaseTableBarController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = MusicVC
            }
        }*/
        
        // 버튼을 누를 때 이전 화면으로 이동
        //navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func youtubeBtnTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.youtube.com/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
