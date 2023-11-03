//
//  MusicListResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/02.
//

import Foundation

struct MusicListResponse: Codable {
    let status: Int
    let message: String
    let data: [MusicInformation]?
}

// MARK: - Datum
struct MusicInformation: Codable {
    let musicID: Int
    let coverImageURL, title, singer: String

    enum CodingKeys: String, CodingKey {
        case musicID = "musicId"
        case coverImageURL = "coverImageUrl"
        case title, singer
    }
}
