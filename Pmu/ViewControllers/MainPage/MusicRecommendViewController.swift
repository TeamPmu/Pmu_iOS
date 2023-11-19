//
//  MusicRecommendViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/30.
//

import UIKit
import MarqueeLabel

class MusicRecommendViewController: UIViewController {
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var youtubeBtn: UIButton!
    
    @IBOutlet weak var musicAlbumImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var bgMusicAlbumImg: UIImageView!
    
    @IBOutlet weak var beforeMusicAlbumImg: UIImageView!
    @IBOutlet weak var nextMusicAlbumImg: UIImageView!
    
    var num = 0
    var heartBtnTap = false
    var liked = false
    var pageIndex = 0
    
    var images: [UIImage] = []
    var imagesURL: [String] = []
    var titles: [String] = []
    var genres: [String] = []
    var artists: [String] = []
    var musicURL: [String] = []
    
    var coverImageUrls: [String] = []
    
    var albumImg: UIImage?
    var titleText: String?
    var artistText: String?
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMusicInformation()
        
        musicAlbumImg.layer.cornerRadius = 12
        musicAlbumImg.clipsToBounds = true
        
        beforeMusicAlbumImg.layer.cornerRadius = 12
        beforeMusicAlbumImg.clipsToBounds = true
        
        nextMusicAlbumImg.layer.cornerRadius = 12
        nextMusicAlbumImg.clipsToBounds = true
        
        // UISwipeGestureRecognizer를 추가
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        swipeLeftGesture.direction = .left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        swipeRightGesture.direction = .right
        self.view.addGestureRecognizer(swipeRightGesture)
        
        for index in 0..<5 {
            UserDefaults.standard.set(false, forKey: "liked\(index)")
            heartBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // UserDefaults에서 모든 liked 값을 초기화 (기존 코드 유지)
        for index in 0..<5 {
            UserDefaults.standard.set(false, forKey: "liked\(index)")
            heartBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    func saveMusic(coverImageUrl: String, title: String, singer: String, youtubeUrl: String){
        guard let appaccessToken = KeyChain.loadToken(forKey: "pmuaccessToken") else {
            // 사용자 토큰이 없으면 이미 로그아웃된 상태
            print("사용자 토큰이 없음. 노래 저장 불가.")
            return
        }
        
        MusicSaveSerivce.musicSave(auth: appaccessToken, coverImageUrl: coverImageUrl, title: title, singer: singer, youtubeUrl: youtubeUrl) { result in
            switch result {
            case .success(let musicSaveResponse):
                if let response = musicSaveResponse as? MusicSaveResponse {
                    let musicData = response.data
                    print("musicData: \(musicSaveResponse)")
                    print("\(title) 노래저장 성공")
                    print("musicID: \(musicData?.musicId)")
                    UserDefaults.standard.set(musicData?.musicId, forKey: coverImageUrl)
                    print(coverImageUrl)
                    print(UserDefaults.standard.string(forKey: coverImageUrl))
                }
            case .requestErr(let errorData):
                //요청이 실패하였을 경우
                print("노래저장 실패 - 요청 오류: \(errorData.message)")
                
            case .serverErr:
                // 서버 오류
                print("노래저장 실패 - 서버 오류")
                
            case .networkFail:
                // 네트워크 오류
                print("노래저장 실패 - 네트워크 오류")
                
            case .pathErr:
                // 경로 오류
                print("노래저장 실패 - 경로 오류")
            }
        }
    }
    
    func deleteMusic(coverImageUrl: String){
        guard let appaccessToken = KeyChain.loadToken(forKey: "pmuaccessToken") else {
            // 사용자 토큰이 없으면 이미 로그아웃된 상태
            print("사용자 토큰이 없음. 노래 삭제 불가.")
            return
        }
        
        guard let musicId = UserDefaults.standard.string(forKey: "\(coverImageUrl)") else {
            // musicID가 없으면 처리할 내용 추가
            print("musicID가 없음. 노래 삭제 불가.")
            return
        }
        
        MusicDeleteService.musicDelete(musicId: musicId, auth: appaccessToken) { result in
            switch result {
            case .success(let musicDeleteResponse):
                print("musicDeleteResponse: \(musicDeleteResponse)")
                print("노래삭제 성공")
                
                UserDefaults.standard.removeObject(forKey: coverImageUrl)
            case .requestErr(let errorData):
                //요청이 실패하였을 경우
                print("노래삭제 실패 - 요청 오류: \(errorData.message)")
            case .serverErr:
                // 서버 오류
                print("노래삭제 실패 - 서버 오류")
            case .networkFail:
                // 네트워크 오류
                print("노래삭제 실패 - 네트워크 오류")
            case .pathErr:
                // 경로 오류
                print("노래삭제 실패 - 경로 오류")
            }
        }
    }
    
    func getMusicInformation() {
        Task {
            do {
                if let emotionToMusicResponse = try await EmotionToMusicDataManager.shared.getEmotionToMusicResponse() {
                    titles = emotionToMusicResponse.Song
                    artists = emotionToMusicResponse.Singer
                    musicURL = emotionToMusicResponse.youtube
                    
                    for coverURLString in emotionToMusicResponse.cover {
                        if let coverImgURL = URL(string: coverURLString),
                           let imageData = try? Data(contentsOf: coverImgURL),
                           let coverImage = UIImage(data: imageData) {
                            images.append(coverImage)
                            imagesURL.append(coverURLString)
                        } else {
                            print("커버 이미지를 가져오는 데 실패했습니다.")
                        }
                    }
                    
                    // 데이터 로딩 후 초기 화면 설정
                    updateUI(with: currentIndex)
                } else {
                    print("EmotionToMusicResponse가 없습니다.")
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func moveToMusicRecommandPage() {
        guard let MusicRecoVC = self.storyboard?.instantiateViewController(withIdentifier: "MusicReco") as? MusicRecommendViewController else { return }
        MusicRecoVC.modalTransitionStyle = .coverVertical
        MusicRecoVC.modalPresentationStyle = .fullScreen
        self.present(MusicRecoVC, animated: true, completion: nil)
    }
    
    func presentMusicIndicatorViewController() {
        let musicIndicatorVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MusicIndicatorView")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(musicIndicatorVC, animated: true)
    }
    
    @IBAction func youtubeBtnTapped(_ sender: UIButton) {
        let urlString = musicURL[currentIndex]
        if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            openURL(url)
        } else {
            print("유효하지 않은 URL입니다.")
        }
    }
    
    func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success {
                        print("URL을 열었습니다.")
                    } else {
                        print("URL을 열 수 없습니다.")
                    }
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                if success {
                    print("URL을 열었습니다.")
                } else {
                    print("URL을 열 수 없습니다.")
                }
            }
        } else {
            print("URL을 열 수 없습니다.")
        }
    }
    
    func presentMainViewController() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "Main")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(mainVC, animated: true)
    }
    
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
        // 'clearTextView' Notification 보내기
        NotificationCenter.default.post(name: NSNotification.Name("clearTextView"), object: nil)
                
        self.dismiss(animated: true){
            self.presentMainViewController()
        }
    }
    
    @IBAction func heartBtnTapped(_ sender: UIButton) {
        // UserDefaults에서 좋아요 상태를 가져오기
        liked = UserDefaults.standard.bool(forKey: "liked\(currentIndex)")
        
        // 좋아요 상태 토글
        liked.toggle()
        
        if liked { //true
            heartBtn.setImage(UIImage(named: "heartYellow"), for: .normal)
            //print("노래 저장 \(currentIndex)")

            if UserDefaults.standard.string(forKey: imagesURL[currentIndex]) != nil {
                print("노래 저장 실패..")
                print("저장 실패 이유: \(UserDefaults.standard.string(forKey: imagesURL[currentIndex]))")
            } else {
                saveMusic(coverImageUrl: imagesURL[currentIndex], title: titles[currentIndex], singer: artists[currentIndex], youtubeUrl: musicURL[currentIndex])
                print("노래 저장 \(currentIndex)")
    
            }
            
        } else {
            heartBtn.setImage(UIImage(named: "heart"), for: .normal)
            
            deleteMusic(coverImageUrl: imagesURL[currentIndex])
        }
        
        // UserDefaults에 좋아요 상태 저장
        UserDefaults.standard.set(liked, forKey: "liked\(currentIndex)")
    }
    
    // UISwipeGestureRecognizer 액션 함수: 왼쪽으로 스와이프할 때 호출됨
    @objc func swipeLeft(_ gesture: UISwipeGestureRecognizer) {
        // 다음 노래로 이동하는 로직을 여기에 추가
        currentIndex += 1
        if currentIndex >= artists.count {
            currentIndex = 0 // 마지막 노래에서 다음 노래로 이동할 경우 첫 번째 노래로 돌아감
        }
        
        // musicAlbumImg에 애니메이션 효과 주기
        UIView.transition(with: musicAlbumImg, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.musicAlbumImg.image = self.images[self.currentIndex]
        }, completion: nil)
        
        UIView.transition(with: bgMusicAlbumImg, duration: 0.6, options: .transitionCrossDissolve, animations: {
            self.bgMusicAlbumImg.image = self.images[self.currentIndex]
        }, completion: nil)
        
        updateUI(with: currentIndex)
    }
    
    // UISwipeGestureRecognizer 액션 함수: 오른쪽으로 스와이프할 때 호출됨
    @objc func swipeRight(_ gesture: UISwipeGestureRecognizer) {
        // 이전 노래로 이동하는 로직을 여기에 추가
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = artists.count - 1 // 첫 번째 노래에서 이전 노래로 이동할 경우 마지막 노래로 돌아감
        }
        
        // musicAlbumImg에 애니메이션 효과 주기
        UIView.transition(with: musicAlbumImg, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.musicAlbumImg.image = self.images[self.currentIndex]
        }, completion: nil)
        
        UIView.transition(with: bgMusicAlbumImg, duration: 0.6, options: .transitionCrossDissolve, animations: {
            self.bgMusicAlbumImg.image = self.images[self.currentIndex]
        }, completion: nil)
        
        
        updateUI(with: currentIndex)
    }
    
    // 노래 정보 업데이트 함수
    func updateUI(with index: Int) {
        // 현재 노래의 좋아요 상태를 가져와서 버튼 이미지 업데이트
        let liked = UserDefaults.standard.bool(forKey: "liked\(currentIndex)")
        
        if liked {
            heartBtn.setImage(UIImage(named: "heartYellow"), for: .normal)
        } else {
            heartBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        if index >= 0 && index < artists.count {
            musicAlbumImg.image = images[index]
            bgMusicAlbumImg.image = images[index]
            titleLbl.text = titles[index]
            artistLbl.text = artists[index]
        }
        
        if index == 0 {
            beforeMusicAlbumImg.image = images[artists.count-1] // 이전 음악 이미지를 nil로 설정
        } else {
            beforeMusicAlbumImg.image = images[index - 1] // 이전 음악 이미지를 업데이트
        }
        
        if index == artists.count - 1 {
            nextMusicAlbumImg.image = images[0] // 다음 음악 이미지를 첫 번째 이미지로 설정
        } else {
            nextMusicAlbumImg.image = images[index + 1] // 다음 음악 이미지를 업데이트
        }
    }
}
