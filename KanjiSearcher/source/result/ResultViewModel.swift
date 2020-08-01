//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol ResultViewModelInput {
    var onQuery: BehaviorRelay<KanjiQuery> { get }
}

protocol ResultViewModelOutput {
    var searchStatus: Driver<KanjiSearchStatus> { get }
}

protocol ResultViewModelType {
    var input: ResultViewModelInput { get }
    var output: ResultViewModelOutput { get }
}
class ResultViewModel: ResultViewModelType, ResultViewModelInput, ResultViewModelOutput {
    var input: ResultViewModelInput { return self }
    var output: ResultViewModelOutput { return self }

    var onQuery: BehaviorRelay<KanjiQuery> = BehaviorRelay.init(value: KanjiQuery.init())

    var searchStatus: Driver<KanjiSearchStatus>

    var kanjiRepository: KanjiRepository

    let disposeBag = DisposeBag()

    init(kanjiRepository: KanjiRepository) {
        self.kanjiRepository = kanjiRepository

        searchStatus = onQuery
            .flatMap { query in
                Observable.concat(
                    Observable.just(KanjiSearchStatus.loading),
                    kanjiRepository
                        .search(query: query)
                        .map { KanjiSearchStatus.success(payload: $0)}
                        .asObservable()
                )
        }
        .asDriver(onErrorRecover: { Driver.just( KanjiSearchStatus.error(error: $0) )})
    }
}
