//

import Foundation

struct KanjiRadical: Equatable {
    let radicalId: Int
    let strokeCount: Int
}

extension KanjiRadical: Decodable {
    enum CodingKeys: String, CodingKey {
        case radicalId = "部首"
        case strokeCount = "内画数"
    }
}
