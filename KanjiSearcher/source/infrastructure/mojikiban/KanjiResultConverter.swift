//

import Foundation

class KanjiResultConverter {
    func convert(_ json: Data) -> KanjiResults {
        let decoder = JSONDecoder.init()
        do {
            return try decoder.decode(KanjiResults.self, from: json)
        } catch {
            return KanjiResults.init(
                status: .error(message: error.localizedDescription), message: error.localizedDescription, count: 0, results: []
            )
        }
    }
}
