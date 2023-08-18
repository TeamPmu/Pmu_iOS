//
//  KakaoLoginResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/16.
//

import Foundation

struct KakaoLoginResponse<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T?
}

struct LoginData: Codable {
    let accessToken: String
    let refreshToken: String
    let profile_image_url: String?
    let nickname: String
}


/* 예시
 struct Welcome: Codable {
     let status: Int
     let message: String
     let data: DataClass
 }


 struct DataClass: Codable {
     let accessToken, refreshToken: String
     let userID: Int
     let profileImageURL: String
     let nickname: String

     enum CodingKeys: String, CodingKey {
         case accessToken, refreshToken
         case userID = "userId"
         case profileImageURL = "profileImageUrl"
         case nickname
     }
}*/
