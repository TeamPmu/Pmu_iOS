//
//  jwtTokenService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/09/17.
//

import Foundation
import Alamofire

struct jwtTokenService {
    private init() {}
    
    static let shared = jwtTokenService()
    
    static func jwtToken (auth: String, completion: @escaping (NetworkResult<jwtTokenResponse>) -> Void){
        let url = APIConstants.jwtURL
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": auth  // Replace with your actual authorization header
        ]
                
        let dataRequest = AF.request(url,
                                     method: .post,
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
                
                print("Received response with signUp Status Code: \(statusCode)")
                print(response)
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(jwtTokenResponse.self, from: data)
                    
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
