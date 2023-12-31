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
    //func deleteItem(atIndex index: Int)
    func reloadTableView()
    func musicList()
    func refresh()
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
    var albumImg: UIImage? = nil
    var albumImgURL: String = ""
    var titleText: String = ""
    var artistText: String = ""
    var musicURL: String = ""
    var musicID: String = ""
    
    weak var delegate: DetailViewControllerDelegate?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        musicDetail(musicID: musicID)
        setHeartButtonImage()
        
        musicAlbumImg.layer.cornerRadius = 12
        //musicAlbumImg.layer.masksToBounds = true
        musicAlbumImg.clipsToBounds = true
                
        print("디테일 musicID: \(musicID)")
    }
    
    func musicDetail(musicID: String){
        guard let appaccessToken = KeyChain.loadToken(forKey: "pmuaccessToken") else {
            // 사용자 토큰이 없으면 이미 로그아웃된 상태
            print("사용자 토큰이 없음. 노래 리스트 불러오기 불가.")
            return
        }
        
        MusicDetailService.musicDetail(musicId: musicID, auth: appaccessToken) { result in
            switch result {
            case .success(let musicDetailResponse):
                if let response = musicDetailResponse as? MusicDetailResponse {
                    let musicData = response.data
                    print("musicDetailResponse: \(musicDetailResponse)")
                    print("노래상세정보 불러오기 성공")
                    
                    DispatchQueue.main.async {
                        if let coverImageURL = URL(string: musicData!.coverImageURL),
                           let imageData = try? Data(contentsOf: coverImageURL),
                           let coverImage = UIImage(data: imageData) {
                            self.musicAlbumImg.image = coverImage
                            self.bgMusicAlbumImg.image = coverImage
                            self.albumImgURL = musicData!.coverImageURL
                        } else {
                            print("커버 이미지를 가져오는 데 실패했습니다.")
                        }
                        
                        self.titleLbl.text = musicData!.title
                        self.artistLbl.text = musicData!.singer
                        self.musicURL = musicData!.youtubeURL
                    }
                    
                } else {
                    // Handle the case where musicData is nil (optional is not set)
                    print("musicData is nil")
                }
                
                //print("musicdataarray: \(musicData)")
                /*images.append(musicData.coverImageURL)
                 titles.append(title)
                 artists.append(artist)
                 musicURLs.append(musicURL)*/
                /*print("\(title) 노래리스트 불러오기 성공")
                 print("musicID: \(musicData?.musicId)")
                 UserDefaults.standard.set(musicData?.musicId, forKey: coverImageUrl)
                 print(coverImageUrl)
                 print(UserDefaults.standard.string(forKey: coverImageUrl))*/
                
            case .requestErr(let errorData):
                //요청이 실패하였을 경우
                print("노래상세정보 불러오기 실패 - 요청 오류: \(errorData.message)")
                
            case .serverErr:
                // 서버 오류
                print("노래상세정보 불러오기 실패 - 서버 오류")
                
            case .networkFail:
                // 네트워크 오류
                print("노래상세정보 불러오기 실패 - 네트워크 오류")
                
            case .pathErr:
                // 경로 오류
                print("노래상세정보 불러오기 실패 - 경로 오류")
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
                
                print(coverImageUrl)
                UserDefaults.standard.removeObject(forKey: coverImageUrl)
                
                self.delegate?.refresh()
                //self.delegate?.reloadTableView()
                
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
        if !self.isHeartSelected {
            deleteMusic(coverImageUrl: albumImgURL)
        }
        
        print(isHeartSelected)
        //print("인덱스", selectedIndex)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func youtubeBtnTapped(_ sender: UIButton) {
        /*if let url = URL(string: musicURL) {
         if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url, options: [:]) { success in
         if success {
         print("URL을 열었습니다.")
         } else {
         print("URL을 열 수 없습니다.")
         }
         }
         } else {
         print("URL을 열 수 없습니다.")
         }
         } else {
         print("유효하지 않은 URL입니다.") //폰에서 안되는 이유는 아마 최신 버전 아니라서 그런듯
         }
         
         print("현재 유튭 url \(musicURL)")*/
        
        // 이미 musicURL이 옵셔널이 아닌 경우
        let urlString = musicURL
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
}
