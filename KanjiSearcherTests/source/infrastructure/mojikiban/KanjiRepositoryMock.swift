//

import Foundation
@testable import KanjiSearcher
import RxSwift

class KanjiRepositoryMock: KanjiRepositoryProtocol {
    var searchCondition: (KanjiQuery) -> KanjiResults = {_ in
        KanjiResults.error(message: "no condition")
    }

    func search(query: KanjiQuery) -> Single<KanjiResults> {
        return Single.just(searchCondition(query))
    }
}
