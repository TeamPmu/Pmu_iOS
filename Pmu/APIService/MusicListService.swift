//
//  MusicListService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/02.
//

import Foundation
import Alamofire

struct MusicListService {
    
    static func musicList(auth: String, completion: @escaping (NetworkResult<MusicListResponse>) -> Void){
        let url = APIConstants.musicListURL /* + "/page=0&size=8"*/
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(auth)"  // Replace with your actual authorization header
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
                    let decodedData = try decoder.decode(MusicListResponse.self, from: data)
                    
                    switch statusCode {
                    case 200..<300:
                        // Update login response in KakaoDataManager
                        //KakaoDataManager.shared.updateLoginResponse(with: decodedData)
                        completion(.success(decodedData))
                    case 400..<500:
                        //let failureData = try decoder.decode(FailureResponse.self, from: data)
                        completion(.requestErr(decodedData))
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
