//
//  MusicDeleteService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/02.
//

import Foundation
import Alamofire

struct MusicDeleteService {
    
    static func musicDelete(musicId: String, auth: String, completion: @escaping (NetworkResult<MusicDeleteResponse>) -> Void){
        let url = APIConstants.deleteMusicURL + "/\(musicId)"
        
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
                    let decodedData = try decoder.decode(MusicDeleteResponse.self, from: data)
                    
                    switch statusCode {
                    case 200..<300:
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
