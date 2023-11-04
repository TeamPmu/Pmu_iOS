//
//  MusicDetailResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/02.
//

import Foundation

// MARK: - Welcome
struct MusicDetailResponse: Codable {
    let status: Int
    let message: String
    let data: MusicDetailData?
}

// MARK: - DataClass
struct MusicDetailData: Codable {
    let musicId: Int
    let coverImageURL, title, singer: String
    let youtubeURL: String

    enum CodingKeys: String, CodingKey {
        case musicId = "musicId"
        case coverImageURL = "coverImageUrl"
        case title, singer
        case youtubeURL = "youtubeUrl"
    }
}
