//

import Foundation
import RxAlamofire
import RxSwift

protocol KanjiRepositoryProtocol {
    func search(query: KanjiQuery) -> Single<KanjiResults>
}

class KanjiRepository: KanjiRepositoryProtocol {
    func search(query: KanjiQuery) -> Single<KanjiResults> {
        return RxAlamofire
            .requestData(.get, query.asUrl())
            .map { (_, data) in
                KanjiResultsConverter().convert(data)
        }
        .asSingle()
    }
}
