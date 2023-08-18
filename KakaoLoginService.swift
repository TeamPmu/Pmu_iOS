//
//  KakaoLoginService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/18.
//

import Foundation
import Alamofire

struct KakaoLoginService {
    static let shared = KakaoLoginService()
    
    func login(completion: @escaping (NetworkResult<Any>) -> Void) {
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
    }
}


