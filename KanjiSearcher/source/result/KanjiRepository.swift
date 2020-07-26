//

import Foundation
import RxAlamofire
import RxSwift

class KanjiRepository {
    func search(query: KanjiQuery) -> Observable<KanjiResults> {
        return RxAlamofire
            .requestData(.get, query.asUrl()!)
            .map { (resoibnse, data) in
                KanjiResultConverter().convert(data)
            }
    }
}
