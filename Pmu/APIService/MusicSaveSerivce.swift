//
//  MusicSaveSerivce.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/02.
//

import Foundation
import Alamofire

struct MusicSaveSerivce {
    
    static func musicSave(auth: String, coverImageUrl: String, title: String, singer: String, youtubeUrl: String, completion: @escaping (NetworkResult<MusicSaveResponse>) -> Void){
        let url = APIConstants.saveMusicURL
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(auth)"  // Replace with your actual authorization header
        ]
        
        let body: Parameters = [
            "coverImageUrl" : coverImageUrl,
            "title": title,
            "singer": singer,
            "youtubeUrl": youtubeUrl]
        
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
                
                print("Received response with musicSave Status Code: \(statusCode)")
                print(response)
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(MusicSaveResponse.self, from: data)
                    
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
