//
//  MusicIndicatorViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/07.
//

import UIKit

class MusicIndicatorViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(self.indicatorView)
        self.indicatorView.startAnimating()
        
        if let emotion = UserDefaults.standard.string(forKey: "emotion"),
           let savedText = UserDefaults.standard.string(forKey: "savedText") {
            // 가져온 emotion 값을 이용하여 Lambda 함수 호출
            emotionToMusic(emotion: emotion, text: savedText)
        } else {
            // "emotion" 또는 "savedText" 키에 대한 값이 없는 경우 처리
            print("No emotion or saved text found in UserDefaults")
        }

        // Do any additional setup after loading the view.
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }*/
    
    func emotionToMusic(emotion: String, text: String){
        EmotionToMusicService.emotionToMusic(emotion: emotion, text: text) { networkResult in
            switch networkResult {
            case .success (let emotionToMusicResponse) :
                if let response = emotionToMusicResponse as? EmotionToMusicResponse {
                    //let MusicData = response.data
                    
                    print("추천음악 받기 성공")
                    
                    // Song 배열 출력
                    for song in response.Song {
                        print("Song: \(song)")
                    }
                    
                    // Singer 배열 출력
                    for singer in response.Singer {
                        print("Singer: \(singer)")
                    }
                    
                    // cover 배열 출력
                    for cover in response.cover {
                        print("Cover: \(cover)")
                    }
                    
                    // youtube 배열 출력
                    for youtube in response.youtube {
                        print("YouTube: \(youtube)")
                    }
                    
                    self.indicatorView.stopAnimating()
                    self.moveToMusicRecommandPage()
                    //self.dismiss(animated: true, completion: nil)
                    
                    /*self.dismiss(animated: true){
                        //self.presentMainViewController()
                        
                        /*let mainVC = UIStoryboard(name: "Main", bundle: nil)
                            .instantiateViewController(withIdentifier: "Main")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                            .changeRootViewController(mainVC, animated: true)*/
                        
                        self.moveToMusicRecommandPage()
                    }*/
                    
                    /*print("Emotion: \(MusicData!.musicAlbumURL)")
                     print("Emotion: \(MusicData!.title)")
                     print("Emotion: \(MusicData!.artist)")*/
                }
                
            case .requestErr(let data):
                print("emotionToMusic request error: \(data)")
                // 요청 에러 처리
                
            case .serverErr:
                print("emotionToMusic server error")
                // 서버 에러 처리
                
            case .networkFail:
                print("emotionToMusic network error")
                // 네트워크 에러 처리
                
            case .pathErr:
                print("emotionToMusic path error")
                // 경로 에러 처리
            }
        }
    }
    
    func moveToMusicRecommandPage() {
        guard let MusicRecoVC = self.storyboard?.instantiateViewController(withIdentifier: "MusicReco") as? MusicRecommendViewController else { return }
        MusicRecoVC.modalTransitionStyle = .coverVertical
        MusicRecoVC.modalPresentationStyle = .fullScreen
        self.present(MusicRecoVC, animated: true, completion: nil)
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
