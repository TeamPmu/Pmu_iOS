//
//  KakaoLogoutService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/09/04.
//

import Foundation
import Alamofire

struct KakaoLogoutService {
    
    private init() {}
    
    static let shared = KakaoLogoutService()
    
    
    static func signout(auth: String, completion: @escaping (NetworkResult<KakaoLogoutResponse>) -> Void){
        let url = APIConstants.signOutURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(auth)" // Replace with your actual authorization header
        ]
        
        print("Sending request to URL: \(url), Method: PATCH")
        
        // Request 생성
        // get통신에서는 encoding에 URLEncoding.default 사용
        // post:  JSONEncoding.default
        let dataRequest = AF.request(url,
                                     method: .patch,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                print("Received response with Status Code: \(statusCode)")
                print(response)
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(KakaoLogoutResponse.self, from: data)
                    
                    switch statusCode {
                    case 200..<300:
                        // Update login response in KakaoDataManager
                        //KakaoDataManager.shared.updateLoginResponse(with: decodedData)
                        completion(.success(decodedData))
                    case 400..<500: completion(.requestErr(decodedData))
                    case 500..<600: completion(.serverErr)
                    default: completion(.networkFail)
                    }
                } catch {
                    print("Decoding failed with error: \(error)")
                    completion(.networkFail)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.networkFail)
            }
        })
    }
    
    static func withdraw(auth: String, completion: @escaping (NetworkResult<KakaoLogoutResponse>) -> Void){
        let url = APIConstants.withDrawURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(auth)"  // Replace with your actual authorization header
        ]
        
        print("Sending request to URL: \(url), Method: DELETE")
        
        // Request 생성
        // get통신에서는 encoding에 URLEncoding.default 사용
        // post:  JSONEncoding.default
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                print("Received response with Status Code: \(statusCode)")
                print(response)
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(KakaoLogoutResponse.self, from: data)
                    
                    switch statusCode {
                    case 200..<300:
                        // Update login response in KakaoDataManager
                        //KakaoDataManager.shared.updateLoginResponse(with: decodedData)
                        completion(.success(decodedData))
                    case 400..<500: completion(.requestErr(decodedData))
                    case 500..<600: completion(.serverErr)
                    default: completion(.networkFail)
                    }
                } catch {
                    print("Decoding failed with error: \(error)")
                    completion(.networkFail)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.networkFail)
            }
        })
    }
}


