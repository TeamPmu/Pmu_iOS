import Foundation

// MARK: - Welcome
struct jwtTokenResponse: Codable {
    let status: Int
    let message: String
    let data: DataClass?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(DataClass.self, forKey: .data)) ?? nil
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let accessToken, refreshToken: String
}
