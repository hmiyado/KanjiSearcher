//

import Foundation

enum KanjiSearchStatus: Equatable {
    case loading
    case success(payload: KanjiResults)
    case error(detail: KanjiResultsError)
}
