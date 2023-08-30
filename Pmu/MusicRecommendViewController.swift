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
    
    var num = 0
    
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

    @IBAction func dismissBtnTapped(_ sender: UIButton) {
        
        //MusicViewController.txtView.text = "" // textView 초기화
        
        // 'clearTextView' Notification 보내기
        NotificationCenter.default.post(name: NSNotification.Name("clearTextView"), object: nil)

        
        self.dismiss(animated: true, completion: nil)
        
       /* let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let musicVC = storyboard.instantiateViewController(withIdentifier: "Main") as? BaseTableBarController {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                
                // musicVC가 루트 뷰 컨트롤러로 나타난 후에 애니메이션 수행
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = musicVC
                }) { _ in
                    // 현재 뷰 컨트롤러를 위에서 아래로 사라지는 애니메이션으로 닫음
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }*/

        
       /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 스토리보드 ID로 두 번째 뷰 컨트롤러 인스턴스화
        if let MusicVC = storyboard.instantiateViewController(withIdentifier: "Main") as? BaseTableBarController {
            // 윈도우 씬을 찾아서 루트 뷰 컨트롤러 변경
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first {
                window.rootViewController = MusicVC
            }
        }*/
        
        
        /*let MainVC =  UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Main")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(MainVC, animated: true)*/
        
        // 버튼을 누를 때 이전 화면으로 이동
        
        //self.dismiss(animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
