//

import RxCocoa
import RxRelay
import RxSwift

protocol SearchViewModelInput {
    var onQueryReading: BehaviorRelay<String> { get }
    var onSearch: PublishRelay<Void> { get }
}

protocol SearchViewModelOutput {
    var search: Driver<KanjiQuery> { get }
}

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput {

    var input: SearchViewModelInput { return self }
    var output: SearchViewModelOutput { return self }

    var onQueryReading: BehaviorRelay<String> = BehaviorRelay.init(value: "")
    var onSearch: PublishRelay<Void> = PublishRelay.init()

    var search: Driver<KanjiQuery>

    let disposeBag = DisposeBag()

    init() {
        search = onSearch
            .withLatestFrom(onQueryReading)
            .filter { !$0.isEmpty }
            .map { KanjiQuery.init(reading: $0) }
            .asDriver(onErrorDriveWith: .empty())
    }
}
