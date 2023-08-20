//
//  APIConstants.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/16.
//

import Foundation

struct APIConstants {
    
    // MARK: - base URL
    
    static let baseURL = "http://3.39.18.66:8080"
    
    // MARK: - Kakao
    
    //카카오 로그인 (get)
    static let signInURL = baseURL + "/api/user/signin"
    
    //카카오 회원가입 (post)
    static let signUpURL = baseURL + "/api/user/signup"
    
    //jwt 재발급 (post)
    static let jwtURL = baseURL + "/api/user/reissue"
}
