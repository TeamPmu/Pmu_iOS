//
//  MusicDeleteResponse.swift
//  Pmu
//
//  Created by seohuibaek on 2023/11/02.
//

import Foundation

struct MusicDeleteResponse: Codable {
    let status: Int
    let message: String
    let data: DataNull?
}

// MARK: - Encode/decode helpers

class DataNull: Codable, Hashable {

    public static func == (lhs: DataNull, rhs: DataNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
