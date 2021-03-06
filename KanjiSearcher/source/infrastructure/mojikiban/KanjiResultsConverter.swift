//

import Foundation

class KanjiResultsConverter {
    func convert(_ json: Data) -> KanjiResults {
        let decoder = JSONDecoder.init()
        do {
            return try decoder.decode(KanjiResults.self, from: json)
        } catch {
            return KanjiResults.error(detail: .unknown(description: error.localizedDescription))
        }
    }
}
