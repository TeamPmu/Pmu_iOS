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
        
        setNickNameLabel()
        
        print(titles.count)
        
        for i in 0..<titles.count {
            print("Title: \(titles[i]), Artist: \(artists[i]), MusicURL: \(musicURLs[i])")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func refresh() {
        // UIRefreshControl 객체 선언
        let refreshControl = UIRefreshControl()
        
        // refreshControl을 테이블 뷰에 연결
        tableView.refreshControl = refreshControl
        
        // refreshControl의 target 및 action 설정
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        // 진입 시 자동으로 새로 고침을 시작
        refreshControl.beginRefreshing()
        
        // 데이터를 초기로드
        refreshData(refreshControl)
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        
        // 이전 데이터를 삭제
        titles.removeAll()
        artists.removeAll()
        images.removeAll()
        musicIDs.removeAll()
        
        // 데이터를 다시 로드하거나 업데이트합니다.
        musicList()
        
        // 데이터 로드가 완료되면 리프레시 컨트롤을 중지합니다.
        sender.endRefreshing()
    }
    
    func musicList(){
        guard let appaccessToken = KeyChain.loadToken(forKey: "pmuaccessToken") else {
            // 사용자 토큰이 없으면 이미 로그아웃된 상태
            print("사용자 토큰이 없음. 노래 리스트 불러오기 불가.")
            return
        }
        
        MusicListService.musicList(auth: appaccessToken) { result in
            switch result {
            case .success(let musicListResponse):
                if let response = musicListResponse as? MusicListResponse {
                    let musicData = response.data
                    print("musicListResponse: \(musicListResponse)")
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
                            print("musicIDs 출력: \(self.musicIDs)")
                        }
                        
                        DispatchQueue.main.async {
                            // UI 업데이트 코드
                            self.tableView.reloadData()
                            
                            self.tabBarController?.tabBar.barTintColor = UIColor.white // 또는 원하는 배경색
                            self.tabBarController?.tabBar.layer.borderWidth = 0
                            self.tabBarController?.tabBar.layer.borderColor = UIColor.clear.cgColor
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
        // 상세보기 모드 처리
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        
        modalViewController.modalPresentationStyle = .fullScreen
        
        modalViewController.musicID = musicIDs[indexPath.row]
        
        present(modalViewController, animated: true, completion: nil)
    }
    
    // 새로운 셀을 추가하는 메서드
    func addNewItem() {
        titles.append("New Item")
        let indexPath = IndexPath(row: titles.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func reloadTableView() {
        tableView.reloadData() // 테이블 뷰 리로드
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                /*destinationVC.albumImg = MusicData.shared.images[indexPath.row]
                destinationVC.titleText = MusicData.shared.titles[indexPath.row]
                destinationVC.artistText = MusicData.shared.artists[indexPath.row]
                destinationVC.musicURL = MusicData.shared.musicURLs[indexPath.row]*/
                
                destinationVC.musicID = musicIDs[indexPath.row]
                // 수정: selectedIndex 설정
                destinationVC.selectedIndex = indexPath.row
                
                destinationVC.delegate = self // delegate를 설정하여 삭제 요청을 받을 수 있도록 함
            }
        }
    }
    
    // 삭제 요청을 처리하는 메서드
    func deleteItem(atIndex index: Int) {
        // 데이터 배열에서 해당 음악 정보 삭제
        let deletedItem = titles[index] // 삭제하기 전 항목을 저장
        titles.remove(at: index)
        artists.remove(at: index)
        images.remove(at: index)
        //MusicData.shared.musicURLs.remove(at: index)
        
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
