//

import Foundation

struct KanjiResults: Equatable {
    var status: KanjiResultStatus
    var message: String
    var find: Bool
    var count: Int
    var results: [KanjiInfo]
}

extension KanjiResults: Decodable {
    init(from decorder: Decoder) throws {
        let values = try decorder.container(keyedBy: CodingKeys.self)
        status = try values.decode(KanjiResultStatus.self, forKey: .status)
        switch status {
        case .success:
            message = ""
        case .error:
            message = try values.decode(String.self, forKey: .message)
            find = false
            count = 0
            results = []
            return
        }
        find = try values.decode(Bool.self, forKey: .find)
        count = try values.decode(Int.self, forKey: .count)

        results = (try? values.decodeArray(forKey: .results)) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case status
        case find
        case count
        case results
        case message
    }

}

enum KanjiResultStatus: String, Codable {
    case success
    case error
}
