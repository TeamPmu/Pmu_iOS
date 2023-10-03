//
//  FailureResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/09/25.
//

struct FailureResponse: Codable {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
