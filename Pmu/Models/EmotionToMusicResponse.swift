//
//  EmotionToMusicResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/10/16.
//

import Foundation

struct EmotionToMusicResponse: Codable {
    let Song: [String]
    let Singer: [String]
    let cover: [String]
    let youtube: [String]
}

class EmotionToMusicDataManager {
    static let shared = EmotionToMusicDataManager() // 싱글톤 인스턴스
    
    private var emotionToMusicResponse: EmotionToMusicResponse?
    private let dataQueue = DispatchQueue(label: "com.yourapp.dataQueue", attributes: .concurrent)
    
    private init() {}
    
    // 데이터 업데이트 메서드
    func updateEmotionToMusicResponse(with response: EmotionToMusicResponse) {
        dataQueue.async(flags: .barrier) {
            self.emotionToMusicResponse = response
            print("EmotionToMusicResponse updated: \(self.emotionToMusicResponse)") // 디버그용 출력
        }
    }
    
    // 데이터를 가져오는 메서드
    func getEmotionToMusicResponse() -> EmotionToMusicResponse? {
        var result: EmotionToMusicResponse?
        dataQueue.sync {
            result = self.emotionToMusicResponse
        }
        print("Getting EmotionToMusicResponse: \(result)") // 디버그용 출력
        return result
    }
}


//싱글톤
/*class EmotionToMusicDataManager {
    static let shared = EmotionToMusicDataManager() // 싱글톤 인스턴스
    
    private init() {}
    
    // 데이터를 저장하는 프로퍼티
    private var emotionToMusicResponse: EmotionToMusicResponse?
    
    // 데이터 업데이트 메서드
    func updateEmotionToMusicResponse(with response: EmotionToMusicResponse) {
        self.emotionToMusicResponse = response
        print("EmotionToMusicResponse updated: \(emotionToMusicResponse)") // 디버그용 출력
    }
    
    // 데이터를 가져오는 메서드
    func getEmotionToMusicResponse() -> EmotionToMusicResponse? {
        print("Getting EmotionToMusicResponse: \(emotionToMusicResponse)") // 디버그용 출력
        return emotionToMusicResponse
    }
}
 
/*struct EmotionToMusicResponse: Codable {
    let status: Int
    let message: String
    let data: MusicData?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(MusicData.self, forKey: .data)) ?? nil
    }
}*/

// MARK: - DataClass
struct MusicData: Codable {
    let musicAlbumURL: String
    let title: String
    let artist: String

    enum CodingKeys: String, CodingKey {
        case musicAlbumURL
        case title
        case artist
    }
}


class MusicDataManager {
    static let shared = MusicDataManager() // 싱글톤 인스턴스
    
    private init() {}
    
    // 데이터를 저장하는 프로퍼티
    private var musicResponse: EmotionToMusicResponse?
    
    // 데이터 업데이트 메서드
    func updateMusicResponse(with response: EmotionToMusicResponse) {
        self.musicResponse = response
        print("music response updated: \(musicResponse)") // 디버그용 출력
    }
    
    // 데이터를 가져오는 메서드
    func getLoginResponse() -> EmotionToMusicResponse? {
        print("music login response: \(musicResponse)") // 디버그용 출력
        return musicResponse
    }
}
*/
