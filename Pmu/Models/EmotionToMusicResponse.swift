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
