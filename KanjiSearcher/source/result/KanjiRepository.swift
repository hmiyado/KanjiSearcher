//

import Foundation
import RxAlamofire
import RxSwift

class KanjiRepository {
    func search(query: KanjiQuery) -> Observable<KanjiResults> {
        return RxAlamofire
            .requestData(.get, query.asUrl()!)
            .map { (_, data) in
                KanjiResultConverter().convert(data)
        }
    }
}
