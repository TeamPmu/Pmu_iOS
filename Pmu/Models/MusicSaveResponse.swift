//
//  MusicSaveResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/02.
//

import Foundation

// MARK: - Welcome
struct MusicSaveResponse: Codable {
    let status: Int
    let message: String
    let data: MusicID?
}

// MARK: - DataClass
struct MusicID: Codable {
    let musicID: Int

    enum CodingKeys: String, CodingKey {
        case musicID = "musicId"
    }
}
