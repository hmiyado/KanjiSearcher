//

import Foundation

struct KanjiResults: Equatable {
    var status: KanjiResultStatus
    var find: Bool
    var count: Int
    var results: [KanjiInfo]
}

extension KanjiResults: Decodable {
    init(from decorder: Decoder) throws {
        let values = try decorder.container(keyedBy: CodingKeys.self)
        status = try values.decode(KanjiResultStatus.self, forKey: .status)
        find = try values.decode(Bool.self, forKey: .find)
        count = try values.decode(Int.self, forKey: .count)

        guard var resultsContainer = try? values.nestedUnkeyedContainer(forKey: .results) else {
            results = []
            return
        }

        var tempResults: [KanjiInfo] = []
        while !resultsContainer.isAtEnd {
            do {
                let kanjiInfoDecoder = try resultsContainer.superDecoder()
                let kanjiInfo = try KanjiInfo.init(from: kanjiInfoDecoder)
                tempResults.append(kanjiInfo)
            } catch {
                // continue
                print("Unexpected error: \(error).")
            }
        }

        results = tempResults
    }

    enum CodingKeys: String, CodingKey {
        case status
        case find
        case count
        case results
    }

}

enum KanjiResultStatus: String, Codable {
    case success
    case error
}
