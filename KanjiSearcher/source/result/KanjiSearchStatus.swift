//

import Foundation

enum KanjiSearchStatus {
    case loading
    case success(payload: KanjiResults)
    case error(error: Error)
}
