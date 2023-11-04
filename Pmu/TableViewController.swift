//
//  TableViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/29.
//

import UIKit

class TableViewController: UITableViewController, DetailViewControllerDelegate {
    
    var data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6","Item 7","Item 8", "Item 9"]
    
    var images: [UIImage] = []
    var titles: [String] = []
    var genres: [String] = []
    var artists: [String] = []
    var musicURLs: [String] = []
    var musicIDs: [String] = []
    
    @IBOutlet weak var nicknameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //navigationBar bottom bolder line 제거하기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 더미 음악 데이터를 가져오는 함수 호출
        //getDummyMusic()
        
        setNickNameLabel()
        
        // NotificationCenter를 통해 데이터를 수신하기 위해 옵저버를 추가합니다.
        //NotificationCenter.default.addObserver(self, selector: #selector(handleLikedMusicData(_:)), name: Notification.Name("MusicDataLiked"), object: nil)
        
        print(titles.count)
        
        for i in 0..<titles.count {
            print("Title: \(titles[i]), Artist: \(artists[i]), MusicURL: \(musicURLs[i])")
        }
        
        musicList()
    }
    
    func musicList(){
        guard let appaccessToken = KeyChain.loadToken(forKey: "pmuaccessToken") else {
            // 사용자 토큰이 없으면 이미 로그아웃된 상태
            print("사용자 토큰이 없음. 노래 리스트 불러오기 불가.")
            return
        }
        
        /*guard let musicId = UserDefaults.standard.string(forKey: "\(coverImageUrl)") else {
            // musicID가 없으면 처리할 내용 추가
            print("musicID가 없음. 노래 삭제 불가.")
            return
        }*/

        MusicListService.musicList(auth: appaccessToken) { result in
            switch result {
            case .success(let musicListResponse):
                if let response = musicListResponse as? MusicListResponse {
                    let musicData = response.data
                    //print("musicData: \(musicListResponse)")
                    print("노래리스트 불러오기 성공")
                    
                    if let musicData = musicData {
                        for musicInfo in musicData {
                            // Your code to process each musicInfo goes here
                            //let coverImageURL = musicInfo.coverImageURL
                            let title = musicInfo.title
                            let artist = musicInfo.singer
                            let musicID = String(musicInfo.musicID)
                            //let musicURL = musicInfo.musicURL
                            
                            //images.append(coverImageURL)
                            self.titles.append(title)
                            self.artists.append(artist)
                            self.musicIDs.append(musicID)
                            
                            //musicURLs.append(musicURL)
                            
                            if let coverImageURL = URL(string: musicInfo.coverImageURL),
                               let imageData = try? Data(contentsOf: coverImageURL),
                               let coverImage = UIImage(data: imageData) {
                                self.images.append(coverImage)
                            } else {
                                print("커버 이미지를 가져오는 데 실패했습니다.")
                            }
                            
                            print("Cover Image URL: \(musicInfo.coverImageURL)")
                            print("Title: \(musicInfo.title)")
                            print("Artist: \(musicInfo.singer)")
                        }
                        
                        DispatchQueue.main.async {
                            // UI 업데이트 코드
                            self.tableView.reloadData()
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
                }
                
            case .requestErr(let errorData):
                //요청이 실패하였을 경우
                print("노래리스트 불러오기 실패 - 요청 오류: \(errorData.message)")
                
            case .serverErr:
                // 서버 오류
                print("노래리스트 불러오기 실패 - 서버 오류")
                
            case .networkFail:
                // 네트워크 오류
                print("노래리스트 불러오기 실패 - 네트워크 오류")
                
            case .pathErr:
                // 경로 오류
                print("노래리스트 불러오기 실패 - 경로 오류")
            }
        }
    }
    
    /*func deleteMusic(coverImageUrl: String){
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
    }*/
    
    // 데이터를 처리하는 메서드를 정의합니다.
    /*@objc func handleLikedMusicData(_ notification: Notification) {
        // NotificationCenter에서 넘어온 데이터를 확인합니다.
        if let userInfo = notification.userInfo {
            if let image = userInfo["image"] as? UIImage,
               let title = userInfo["title"] as? String,
               let artist = userInfo["artist"] as? String,
               let musicURL = userInfo["musicURL"] as? String {
                
                images.append(image)
                titles.append(title)
                artists.append(artist)
                musicURLs.append(musicURL)
            }
        }
        
        print("저장 된 노래,, \(images),\(titles),\(artists),\(musicURLs)")
    }

    // 반드시 뷰 컨트롤러가 해제될 때 NotificationCenter 옵저버를 제거해야 합니다.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    */
    func setNickNameLabel() {
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            let nickname = loginResponse.data!.nickname
            let formattedNickname = "\(nickname) 님을 위한"
            print("변경된 닉네임: \(formattedNickname)") // 디버그 출력
            nicknameLbl.text = formattedNickname
        } else {
            print("로그인 응답 데이터가 없음") // 디버그 출력
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return images.count
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell", for: indexPath) as! TableViewCell
         cell.titleLbl?.text = titles[indexPath.row]
         cell.artistLbl?.text = artists[indexPath.row]
         cell.musicAlbumImg?.image = images[indexPath.row]
         return cell
        
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell", for: indexPath) as! TableViewCell
        // MusicData 모델 클래스를 사용하여 데이터를 표시
        cell.titleLbl?.text = MusicData.shared.titles[indexPath.row]
        cell.artistLbl?.text = MusicData.shared.artists[indexPath.row]
        cell.musicAlbumImg?.image = MusicData.shared.images[indexPath.row]
        return cell*/
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀에 대한 동작을 정의
        
        //tableView.deselectItem(at: indexPath, animated: true)
        
        // 상세보기 모드 처리
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        
        modalViewController.modalPresentationStyle = .fullScreen
        // 선택한 이미지를 모달 뷰 컨트롤러에 전달
        /*modalViewController.albumImg = MusicData.shared.images[indexPath.row]
        modalViewController.titleText = MusicData.shared.titles[indexPath.row]
        modalViewController.artistText = MusicData.shared.artists[indexPath.row]
        modalViewController.musicURL = MusicData.shared.musicURLs[indexPath.row]*/
        //modalViewController.genreText = "Genre: " + genres[indexPath.row]
        
        modalViewController.musicID = musicIDs[indexPath.row]
        
        present(modalViewController, animated: true, completion: nil)
    }
    
    // 새로운 셀을 추가하는 메서드
    func addNewItem() {
        titles.append("New Item")
        let indexPath = IndexPath(row: titles.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
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
            name: "모든 것이 꿈이었네 (It Was All a Dream) ",
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
                musicURLs.append(dummyMusic.musicPull)
            }
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                /*destinationVC.albumImg = MusicData.shared.images[indexPath.row]
                destinationVC.titleText = MusicData.shared.titles[indexPath.row]
                destinationVC.artistText = MusicData.shared.artists[indexPath.row]
                destinationVC.musicURL = MusicData.shared.musicURLs[indexPath.row]*/
                
                //destinationVC.musicID = musicIDs[indexPath.row]
                // 수정: selectedIndex 설정
                destinationVC.selectedIndex = indexPath.row
                
                destinationVC.delegate = self // delegate를 설정하여 삭제 요청을 받을 수 있도록 함
            }
        }
    }*/
    
    // 삭제 요청을 처리하는 메서드
    func deleteItem(atIndex index: Int) {
        // 데이터 배열에서 해당 음악 정보 삭제
        let deletedItem = MusicData.shared.titles[index] // 삭제하기 전 항목을 저장
        MusicData.shared.titles.remove(at: index)
        MusicData.shared.artists.remove(at: index)
        MusicData.shared.images.remove(at: index)
        MusicData.shared.musicURLs.remove(at: index)
        
        // 테이블 뷰 업데이트
        tableView.beginUpdates() // 업데이트 시작
        
        // 테이블 뷰에서 해당 셀 삭제
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        
        tableView.endUpdates() // 업데이트 종료
        
        // 삭제하기 전과 후의 배열을 비교하여 변경된 항목 확인
        if !titles.contains(deletedItem) {
            print("\(deletedItem) 항목이 삭제되었습니다.")
        } else {
            print("\(deletedItem) 항목은 삭제되지 않았습니다.")
        }
    }
}
