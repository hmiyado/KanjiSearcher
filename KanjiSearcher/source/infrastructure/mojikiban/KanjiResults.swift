//

import Foundation

enum KanjiResults: Equatable {
    case success(count: Int, results: [KanjiInfo])
    case error(detail: KanjiResultsError)
}

extension KanjiResults: Decodable {
    init(from decorder: Decoder) throws {
        let values = try decorder.container(keyedBy: CodingKeys.self)
        let status = try values.decode(String.self, forKey: .status)
        switch status {
        case "success":
            let count = try values.decode(Int.self, forKey: .count)
            let results = values.contains(.results) ?
                try values.decode(Array<KanjiInfo>.self, forKey: .results) :
                []
            self = .success(count: count, results: results)
        case "error":
            let message = try values.decode(String.self, forKey: .message)
            switch message {
            case "Invalid Parameters":
                self = .error(detail: .invalidParameters)
            case "Empty Query":
                self = .error(detail: .emptyQuery)
            default:
                self = .error(detail: .unknown(description: message))
            }
        default:
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.status, in: values, debugDescription: "unexpected value \(status)")
        }

    }

    enum CodingKeys: String, CodingKey {
        case status
        case count
        case results
        case message
    }

}

enum KanjiResultsError: Error {
    case invalidParameters
    case emptyQuery
    case unknown(description: String)
}

extension KanjiResultsError: Equatable {

}
