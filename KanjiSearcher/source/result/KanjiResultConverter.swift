//

import Foundation

class KanjiResultConverter {
    func convert(_ json: Data) -> KanjiResults? {
        let decoder = JSONDecoder.init()
        return try? decoder.decode(KanjiResults.self, from: json)
    }
}
