//

import Foundation
import RxAlamofire
import RxSwift

class KanjiRepository {
    func search(query: KanjiQuery) -> Single<KanjiResults> {
        return RxAlamofire
            .requestData(.get, query.asUrl())
            .map { (_, data) in
                KanjiResultConverter().convert(data)
        }
        .asSingle()
    }
}
