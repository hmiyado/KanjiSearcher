//

import RxCocoa
import RxRelay
import RxSwift

protocol SearchViewModelInput {
    var onQueryReading: BehaviorRelay<String> { get }
    var onSearch: PublishRelay<Void> { get }
}

protocol SearchViewModelOutput {
    var isSearchable: Driver<Bool> { get }
    var search: Driver<KanjiQuery> { get }
}

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput {

    // MARK: SearchViewModelType
    var input: SearchViewModelInput { return self }
    var output: SearchViewModelOutput { return self }

    // MARK: SearchViewModelInput
    var onQueryReading: BehaviorRelay<String> = BehaviorRelay.init(value: "")
    var onSearch: PublishRelay<Void> = PublishRelay.init()

    // MARK: SearchViewModelOutput
    var isSearchable: Driver<Bool>
    var search: Driver<KanjiQuery>

    // MARK: properties
    private let disposeBag = DisposeBag()

    // MARK: initializer
    init() {
        search = onSearch
            .withLatestFrom(onQueryReading)
            .filter { !$0.isEmpty }
            .map { KanjiQuery.init(reading: $0) }
            .asDriver(onErrorDriveWith: .empty())

        isSearchable = onQueryReading
            .map { queryReading in
                KanjiQuery.isValidReading(queryReading)
        }
        .asDriver(onErrorDriveWith: .just(false))
    }
}
