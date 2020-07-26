//

import Foundation

struct KanjiResults: Decodable, Equatable {
    //    var status: KanjiResultStatus
    var find: Bool
    var count: Int
    //    var results: [KanjiInfo]
}

enum KanjiResultStatus {
    case success
    case error
}
