//

import RxCocoa
import RxRelay
import RxSwift

protocol SearchViewModelInput {
    var onQueryReading: BehaviorRelay<String> { get }
    var onEndEditing: PublishRelay<Void> { get }
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
    let onQueryReading: BehaviorRelay<String> = BehaviorRelay.init(value: "")
    let onEndEditing: PublishRelay<Void> = PublishRelay.init()
    let onSearch: PublishRelay<Void> = PublishRelay.init()

    // MARK: SearchViewModelOutput
    let isSearchable: Driver<Bool>
    let search: Driver<KanjiQuery>

    // MARK: properties
    private let disposeBag = DisposeBag()

    // MARK: initializer
    init(scheduler: SchedulerType = MainScheduler.instance) {
        isSearchable = onQueryReading
            .map { queryReading in
                KanjiQuery.isValidReading(queryReading)
            }
            .asDriver(onErrorDriveWith: .just(false))

        search = Observable<Void>
            .merge(onSearch.asObservable(), onEndEditing.asObservable())
            .throttle(RxTimeInterval.milliseconds(500), latest: false, scheduler: scheduler)
            .withLatestFrom(isSearchable) { _, isSearchable in isSearchable }
            .filter { $0 }
            .withLatestFrom(onQueryReading)
            .filter { !$0.isEmpty }
            .map { KanjiQuery.init(reading: $0) }
            .asDriver(onErrorDriveWith: .empty())
    }
}
