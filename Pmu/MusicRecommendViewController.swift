//
//  MusicRecommendViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit

class MusicRecommendViewController: UIViewController {

    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var musicAlbumImg: UIImageView!
    @IBOutlet weak var youtubeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //dismissBtn.layer.cornerRadius = 24
        //dismissBtn.clipsToBounds = true
        
        //heartBtn.layer.cornerRadius = 24
        //heartBtn.clipsToBounds = true
        
        musicAlbumImg.layer.cornerRadius = 12
        musicAlbumImg.clipsToBounds = true
    }
    /*
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
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
    */
    
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
