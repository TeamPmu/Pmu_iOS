//
//  EmotionToMusicService.swift
//  Pmu
//
//  Created by seohuibaek on 2023/10/16.
//

import Foundation
import Alamofire

class EmotionToMusicService {
    static let shared = EmotionToMusicService()
    
    // ... (이전 코드)
    
    static func emotionToMusic (emotion: String, text: String, completion: @escaping (NetworkResult<EmotionToMusicResponse>) -> Void){
        let url = APIConstants.emotionToMusicURL
        
        let headers: HTTPHeaders = [
            // Replace with your actual authorization header
            "Content-Type": "application/json",
        ]
        
        let body: Parameters = ["emotion": emotion, "text": text]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
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
                
                print("Received response with EmotionToMusic Status Code: \(statusCode)")
                print(response)
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(EmotionToMusicResponse.self, from: data)
                    
                    switch statusCode {
                    case 200..<300:
                        EmotionToMusicDataManager.shared.updateEmotionToMusicResponse(with: decodedData)
                        completion(.success(decodedData))
                    case 400..<500:
                        completion(.requestErr(decodedData))
                    case 500..<600:
                        completion(.serverErr)
                    default:
                        completion(.networkFail)
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
