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
    @IBOutlet weak var youtubeBtn: UIButton!
    
    @IBOutlet weak var musicAlbumImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var bgMusicAlbumImg: UIImageView!
    
    @IBOutlet weak var beforeMusicAlbumImg: UIImageView!
    @IBOutlet weak var nextMusicAlbumImg: UIImageView!
    
    
    var num = 0
    var heartBtnTap = true
    var pageIndex = 0
    
    var images: [UIImage] = []
    var titles: [String] = []
    var genres: [String] = []
    var artists: [String] = []
    var musicURL: [String] = []
    
    var albumImg: UIImage?
    var titleText: String?
    var artistText: String?
    var currentIndex: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 더미 음악 데이터를 가져오는 함수 호출
        getDummyMusic()

        print(artists.count)
        
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
        
        // 초기 화면 설정
        updateUI(with: currentIndex)
    }

    @IBAction func youtubeBtnTapped(_ sender: UIButton) {
        
        if let url = URL(string: musicURL[currentIndex]) {
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
    }
    
    @IBAction func heartBtnTapped(_ sender: UIButton) {
        if heartBtnTap == false {
            heartBtn.setImage(UIImage(named: "heartYellow"), for: .normal)
            num+=1
            
            heartBtnTap = true
        } else {
            heartBtn.setImage(UIImage(named: "heart"), for: .normal)
            num+=1
            heartBtnTap = false
        }
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
        
        heartBtnTapped(heartBtn)
        
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
    
    //DummyMusic 갖고오기
    func getDummyMusic(){
        let dummyMusic1: AroundMusic = AroundMusic(
            name: "Attention",
            coverImg: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/a8/e2/1b/a8e21b3b-9c8d-2974-2318-6bcd4c9d2370/075679884336.jpg/100x100bb.jpg",
            genre: "pop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/b5/32/d4/b532d45b-0e4d-6bf3-d7b5-e02007877318/mzaf_10109990520611630125.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=6QYcd7RggNU",
            replyCnt: 0,
            archiveId: 0,
            artist: "Charlie Puth",
            pickCnt: 0)
        
        let dummyMusic2: AroundMusic = AroundMusic(
            name: "Attention",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music112/v4/4e/64/34/4e64344b-3ac6-c503-2c41-257a15401416/192641873096_Cover.jpg/100x100bb.jpg",
            genre: "kpop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/13/79/51/13795136-c3d0-1191-cc43-dcc16579a2f2/mzaf_8604667655746746744.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=o8RkbHv2_a0",
            replyCnt: 0,
            archiveId: 0,
            artist: "NewJeans",
            pickCnt: 0)
        
        let dummyMusic3: AroundMusic = AroundMusic(
            name: "Sanso (Interlude)",
            coverImg: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/76/bc/37/76bc37d2-283d-f252-716e-183c268b8a87/197189280801.jpg/100x100bb.jpg",
            genre: "hiphop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/fc/05/e9/fc05e999-0e4f-2a28-e21d-3fd55a671208/mzaf_13793805966112651018.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=JaJCPjd4iE8",
            replyCnt: 0,
            archiveId: 0,
            artist: "Beenzino",
            pickCnt: 0)
        
        let dummyMusic4: AroundMusic = AroundMusic(
            name: "모든 것이 꿈이었네 (It Was All a Dream)",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music126/v4/b5/9c/27/b59c2792-bb97-2a40-f482-c6d5b3ae1cea/196626603180.jpg/100x100bb.jpg",
            genre: "hiphop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/79/97/b3/7997b3fd-b8b8-0540-787a-0ef0988e807c/mzaf_6188522879362145428.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=xICSRpVzATI",
            replyCnt: 0,
            archiveId: 0,
            artist: "250",
            pickCnt: 0)
        
        let dummyMusic5: AroundMusic = AroundMusic(
            name: "Slay",
            coverImg: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/02/6a/99/026a998e-835f-81a9-d5e5-f0fbf091caf7/cover-C_JAMM_NEW.jpg/100x100bb.jpg",
            genre: "hiphop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/2c/7d/fc/2c7dfcb8-4c6b-f691-9c76-8fe499c3d6b7/mzaf_3230752141782334299.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=r67UF7Wpl08",
            replyCnt: 0,
            archiveId: 0,
            artist: "C JAMM",
            pickCnt: 0)
        
        let dummyMusic6: AroundMusic = AroundMusic(
            name: "Super Shy",
            coverImg: "https://is4-ssl.mzstatic.com/image/thumb/Music126/v4/63/e5/e2/63e5e2e4-829b-924d-a1dc-8058a1d69bd4/196922462702_Cover.jpg/100x100bb.jpg",
            genre: "kpop",
            musicPre: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/98/66/db/9866dbb4-6e6f-eedd-ea1c-4832542b8f3e/mzaf_1940197871229851903.plus.aac.p.m4a",
            musicPull: "https://www.youtube.com/watch?v=ArmDp-zijuc",
            replyCnt: 0,
            archiveId: 0,
            artist: "NewJeans",
            pickCnt: 0)
        
        let dummyMusics: [AroundMusic] = [dummyMusic1, dummyMusic2, dummyMusic3, dummyMusic4, dummyMusic5, dummyMusic6]
        
        // 더미 음악 데이터에서 coverImg URL을 사용하여 UIImage 배열 생성
        for dummyMusic in dummyMusics {
            if let coverImgURL = URL(string: dummyMusic.coverImg),
               let imageData = try? Data(contentsOf: coverImgURL),
               let coverImage = UIImage(data: imageData) {
                
                images.append(coverImage)
                titles.append(dummyMusic.name) // 음악 이름 배열에 추가
                genres.append(dummyMusic.genre) // 장르 배열에 추가
                artists.append(dummyMusic.artist) // 아티스트 배열에 추가
                musicURL.append(dummyMusic.musicPull)
            }
        }
    }
}
