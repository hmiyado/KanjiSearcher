//

import Foundation

struct KanjiResults: Equatable {
    var status: KanjiResultStatus
    var message: String
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
            count = 0
            results = []
            return
        }
        count = try values.decode(Int.self, forKey: .count)

        if values.contains(.results) {
            results = try values.decode(Array<KanjiInfo>.self, forKey: .results)
        } else {
            results = []
        }
    }

    enum CodingKeys: String, CodingKey {
        case status
        case count
        case results
        case message
    }

}

enum KanjiResultStatus: String, Codable {
    case success
    case error
}
