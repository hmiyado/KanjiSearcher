//

import Foundation
@testable import KanjiSearcher
import RxSwift

class KanjiRepositoryMock: KanjiRepositoryProtocol {
    var searchCondition: (KanjiQuery) -> KanjiResults = {_ in
        KanjiResults.init(status: .error(message: "no condition"), message: "no condition", count: 0, results: [])
    }

    func search(query: KanjiQuery) -> Single<KanjiResults> {
        return Single.just(searchCondition(query))
    }
}
