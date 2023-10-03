//
//  KakaoLoginResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/16.
//

import Foundation

/*struct KakaoLoginResponse<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T?
}

struct LoginData: Codable {
    let accessToken: String
    let refreshToken: String
    let profile_image_url: String?
    let nickname: String
}*/


/*struct KakaoLoginResponse: Codable {
    let status: Int
    let message: String
    let data: LoginData
}

struct LoginData: Codable {
    let accessToken, refreshToken: String
    let userID: Int
    let profileImageURL: String?
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
        case userID = "userId"
        case profileImageURL = "profileImageUrl"
        case nickname
    }
}*/

/*struct KakaoLoginResponse: Codable {
    let status: Int
    let message: String
    let data: LoginData
}

struct LoginData: Codable {
    let accessToken: String
    let refreshToken: String
    let userID: Int
    let profileImageURL: String?
    let nickname: String

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken, userID, profileImageURL = "profile_image_url", nickname
    }
}*/

struct KakaoLoginResponse: Codable {
    let status: Int
    let message: String
    let data: LoginData?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(LoginData.self, forKey: .data)) ?? nil
    }
}

// MARK: - DataClass
struct LoginData: Codable {
    let accessToken, refreshToken: String
    let userID: Int
    let profileImageURL: String?
    let nickname: String

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
        case userID = "userId"
        case profileImageURL = "profileImageUrl"
        case nickname
    }
}

class KakaoDataManager {
    static let shared = KakaoDataManager() // 싱글톤 인스턴스
    
    private init() {}
    
    // 데이터를 저장하는 프로퍼티
    private var loginResponse: KakaoLoginResponse?
    
    // 데이터 업데이트 메서드
    func updateLoginResponse(with response: KakaoLoginResponse) {
        self.loginResponse = response
        print("Login response updated: \(loginResponse)") // 디버그용 출력
    }
    
    // 데이터를 가져오는 메서드
    func getLoginResponse() -> KakaoLoginResponse? {
        print("Getting login response: \(loginResponse)") // 디버그용 출력
        return loginResponse
    }
}

