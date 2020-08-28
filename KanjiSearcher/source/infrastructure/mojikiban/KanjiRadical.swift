//

import Foundation

struct KanjiRadical: Equatable {
    let radicalId: Int
    let strokeCount: Int
    var string: String {
        // Unicode 2F00 - 2FD5 are radicals
        // http://www.unicode.org/charts/PDF/U2F00.pdf
        String.init(Unicode.Scalar.init(radicalId - 1 + 0x2F00)!)
    }
}

extension KanjiRadical: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        radicalId = try values.decode(Int.self, forKey: .radicalId)
        if values.contains(.strokeCount) {
            strokeCount = try values.decode(Int.self, forKey: .strokeCount)
        } else {
            strokeCount = 0
        }
    }

    enum CodingKeys: String, CodingKey {
        case radicalId = "部首"
        case strokeCount = "内画数"
    }
}
