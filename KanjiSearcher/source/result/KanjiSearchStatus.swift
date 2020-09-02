//

import Foundation

enum KanjiSearchStatus: Equatable {
    case loading
    case success(payload: KanjiResults)
    case error(error: KanjiSearchError)
}

class KanjiSearchError: Error {
    private    let message: String

    init(error: Error) {
        self.message = error.localizedDescription
    }

    init?(kanjiResults: KanjiResults) {
        switch kanjiResults {
        case .success:
            return nil
        case .error(let detail):
            self.message = detail.localizedDescription
        }
    }
}

extension KanjiSearchError: Equatable {
    static func == (lhs: KanjiSearchError, rhs: KanjiSearchError) -> Bool {
        return lhs.message == rhs.message
    }
}
