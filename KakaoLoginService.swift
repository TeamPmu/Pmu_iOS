//
//  KakaoLoginService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/18.
//

import Foundation
import Alamofire

struct KakaoLoginService {
    
    private init() {}
    
    static let shared = KakaoLoginService()
    
    /*func login(completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.signInURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "auth"  // Replace with your actual authorization header
        ]
        
        // Request 생성
        // get통신에서는 encoding에 URLEncoding.default 사용
        // post:  JSONEncoding.default
        let dataRequest = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        
        // Request 시작
        dataRequest.responseData { response in
            switch response.result {
                // 성공 시 상태코드와 데이터(value) 수신
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                
                let networkResult = NetworkHelper.parseJSON(by: statusCode, data: value, type: LoginData.self)
                completion(networkResult)
                
                // 실패 시 networkFail(통신 실패)신호 전달
            case .failure:
                completion(.badRequest)
            }
        }
    }*/
    
    static func login(auth: String, completion: @escaping (NetworkResult<KakaoLoginResponse>) -> Void){
        let url = APIConstants.signInURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": auth  // Replace with your actual authorization header
        ]
        
        print("Sending request to URL: \(url), Method: GET")
        
        // Request 생성
        // get통신에서는 encoding에 URLEncoding.default 사용
        // post:  JSONEncoding.default
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                print("Received response with Status Code: \(statusCode)")
                
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(LoginData.self, from: data) else {return}
                
                let kakaoResponse = KakaoLoginResponse(status: statusCode, message: "", data: decodedData)
                            
                switch statusCode {
                case 200..<300: completion(.success(kakaoResponse))
                case 400..<500: completion(.requestErr(kakaoResponse))
                case 500..<600: completion(.serverErr)
                default: completion(.networkFail)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.networkFail)
            }
        })
    }
    
    static func signUp (auth: String, nickname: String, completion: @escaping (NetworkResult<KakaoLoginResponse>) -> Void){
        let url = APIConstants.signUpURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": auth  // Replace with your actual authorization header
        ]
        let body: Parameters = ["nickname" : nickname]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                print("Received response with Status Code: \(statusCode)")
                
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(LoginData.self, from: data) else {return}
                
                let kakaoResponse = KakaoLoginResponse(status: statusCode, message: "", data: decodedData)
                            
                switch statusCode {
                case 200..<300: completion(.success(kakaoResponse))
                case 400..<500: completion(.requestErr(kakaoResponse))
                case 500..<600: completion(.serverErr)
                default: completion(.networkFail)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.networkFail)
            }
        })
    }
}


