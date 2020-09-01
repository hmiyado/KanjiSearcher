//

import Foundation

struct KanjiResults: Equatable {
    var status: KanjiResultStatus
    var results: [KanjiInfo]
}

extension KanjiResults: Decodable {
    init(from decorder: Decoder) throws {
        let values = try decorder.container(keyedBy: CodingKeys.self)
        let status = try values.decode(String.self, forKey: .status)
        switch status {
        case "success":
            let count = try values.decode(Int.self, forKey: .count)
            self.status = .success(count: count)
        case "error":
            let message = try values.decode(String.self, forKey: .message)
            self.status = .error(message: message)
            results = []
            return
        default:
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.status, in: values, debugDescription: "unexpected value \(status)")
        }

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

enum KanjiResultStatus: Equatable {
    case success(count: Int)
    case error(message: String)
}
