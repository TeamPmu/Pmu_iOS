//
//  APIConstants.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/16.
//

import Foundation

struct APIConstants {
    
    // MARK: - base URL
    
    //static let baseURL = "http://3.39.18.66:8080"
    
    static let baseURL = "https://gbsadhqz30.execute-api.ap-northeast-2.amazonaws.com/pmu-api-gateway"
    
    // MARK: - Kakao
    
    //카카오 로그인 (get)
    static let signInURL = baseURL + "/api/user/signin"
    
    //카카오 회원가입 (post)
    static let signUpURL = baseURL + "/api/user/signup"
    
    //jwt 재발급 (post)
    static let jwtURL = baseURL + "/api/user/reissue"
    
    //로그아웃 (patch)
    static let signOutURL = baseURL + "/api/user/signout"
    
    //회원탈퇴 (delete)
    static let withDrawURL = baseURL + "/api/user/withdraw"
    
    //AI 프사 -> 감정
    static let imgToEmotionURL = baseURL + "/api/ai/emotion"
    
    //AI 감정 -> 노래 추천
    static let emotionToMusicURL = baseURL + "/api/ai/lyrics"
    
    //음악 저장 (post)
    static let saveMusicURL = baseURL + "/api/music"
    
    //음악 삭제 (delete)
    static let deleteMusicURL = baseURL + "/api/music"
    
    //플레이리스트 로드 (get)
    static let musicListURL = baseURL + "/api/music"
    
    //음악 상세보기 (post)
    static let musicDetailURL = baseURL + "/api/music"
}
