//
//  ImgToEmotionService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/10/16.
//

import Foundation
import Alamofire

class ImgToEmotionService {
    static let shared = ImgToEmotionService()
    
    /*
    static func ImgToEmotion(profileUrl: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = APIConstants.imgToEmotionURL
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "profileUrl": profileUrl// Replace with your actual authorization header
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }*/
    
    static func ImgToEmotion (profileURL: String, completion: @escaping (NetworkResult<ImgToEmotionResponse>) -> Void){
        let url = APIConstants.imgToEmotionURL
        let authToken = "YOUR_AUTH_TOKEN"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authToken)",
            "Content-Type": "application/json",
            //"profileURL": profileURL  // Replace with your actual authorization header
            //"url" : profileURL
        ]
        
        let body: Parameters = ["url" : profileURL]
        
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
                
                print("Received response with imgToEmotion Status Code: \(statusCode)")
                print(response)
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(ImgToEmotionResponse.self, from: data)
                    
                    switch statusCode {
                    case 200..<300:
                        completion(.success(decodedData))
                    case 400..<500:
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
