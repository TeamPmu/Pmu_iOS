//
//  KakaoLogInService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/16.
//

// KakaoLoginService.swift

import Foundation
import Alamofire

struct KakaoLoginService {
    static let shared = KakaoLoginService()
    
    func login(completion: @escaping (NetworkResult<KakaoLoginResponse>) -> Void) {
        let url = APIConstants.signInURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "auth"  // Replace with your actual authorization header
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: KakaoLoginResponse.self) { response in
                switch response.result {
                case .success(let kakaoResponse):
                    if response.response?.statusCode == 201 {
                        completion(.created)
                    } else {
                        completion(.success(kakaoResponse))
                    }
                case .failure(let error):
                    let networkError = self.mapError(error: error)
                    completion(.failure(networkError))
                }
            }
    }
    
    private func mapError(error: AFError) -> NetworkError {
        switch error {
        case .invalidURL:
            return .badRequest
        case .responseValidationFailed:
            if let statusCode = error.responseCode {
                switch statusCode {
                case 401:
                    return .unauthorized
                case 403:
                    return .forbidden
                case 404:
                    return .notFound
                case 405:
                    return .methodNotAllowed
                case 409:
                    return .conflict
                case 500:
                    return .internalServerError
                default:
                    return .unknown
                }
            }
            return .unknown
        default:
            return .unknown
        }
    }
}
