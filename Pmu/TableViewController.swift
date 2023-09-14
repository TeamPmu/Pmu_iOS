//
//  TableViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/29.
//

import UIKit

class TableViewController: UITableViewController {
    
    var data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6","Item 7","Item 8", "Item 9"]
    
    var images: [UIImage] = []
    var titles: [String] = []
    var genres: [String] = []
    var artists: [String] = []
    var musicURL: [String] = []
    
    @IBOutlet weak var nicknameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MusicTableCell")

        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //navigationBar bottom bolder line 제거하기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //navigationController?.isToolbarHidden = true
        
        // 빈 뷰를 생성하여 tableFooterView로 설정
        //let emptyFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        //tableView.tableFooterView = emptyFooterView
        
        // 더미 음악 데이터를 가져오는 함수 호출
        getDummyMusic()
        
        setNickNameLabel()
    }
    
    func setNickNameLabel() {
        if let loginResponse = KakaoDataManager.shared.getLoginResponse() {
            let nickname = loginResponse.data.nickname
            let formattedNickname = "\(nickname) 님을 위한"
            print("변경된 닉네임: \(formattedNickname)") // 디버그 출력
            nicknameLbl.text = formattedNickname
        } else {
            print("로그인 응답 데이터가 없음") // 디버그 출력
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell", for: indexPath) as! TableViewCell
        cell.titleLbl?.text = titles[indexPath.row]
        cell.artistLbl?.text = artists[indexPath.row]
        cell.musicAlbumImg?.image = images[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀에 대한 동작을 정의
        
        //tableView.deselectItem(at: indexPath, animated: true)
        
        // 상세보기 모드 처리
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        
        modalViewController.modalPresentationStyle = .fullScreen
        // 선택한 이미지를 모달 뷰 컨트롤러에 전달
        modalViewController.albumImg = images[indexPath.row]
        modalViewController.titleText = titles[indexPath.row]
        modalViewController.artistText = artists[indexPath.row]
        modalViewController.musicURL = musicURL[indexPath.row]
        //modalViewController.genreText = "Genre: " + genres[indexPath.row]
        
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
