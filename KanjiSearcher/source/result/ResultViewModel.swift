//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol ResultViewModelInput {
    var onQuery: BehaviorRelay<KanjiQuery> { get }
}

protocol ResultViewModelOutput {
    var waitSearching: Driver<Void> {get}
    var successSearching: Driver<KanjiResults> { get }
    var errorSearching: Driver<KanjiSearchError> { get }
}

protocol ResultViewModelType {
    var input: ResultViewModelInput { get }
    var output: ResultViewModelOutput { get }
}
class ResultViewModel: ResultViewModelType, ResultViewModelInput, ResultViewModelOutput {
    // MARK: ResultViewModelType
    var input: ResultViewModelInput { return self }
    var output: ResultViewModelOutput { return self }

    // MARK: ResultViewModelInput
    var onQuery: BehaviorRelay<KanjiQuery> = BehaviorRelay.init(value: KanjiQuery.init())

    // MARK: ResultViewModelOutput
    var waitSearching: Driver<Void>
    var successSearching: Driver<KanjiResults>
    var errorSearching: Driver<KanjiSearchError>

    // MARK: properties
    private var kanjiRepository: KanjiRepositoryProtocol
    private let disposeBag = DisposeBag()

    private let searchingStatus: PublishRelay<KanjiSearchStatus> = PublishRelay.init()

    init(kanjiRepository: KanjiRepositoryProtocol) {
        self.kanjiRepository = kanjiRepository
        self.waitSearching = self.searchingStatus
            .filter { $0 == .loading }
            .map { _ in  () }
            .asDriver(onErrorDriveWith: .empty())
        self.errorSearching = self.searchingStatus
            .compactMap { status in
                switch status {
                case .error(error: let error):
                    return error
                default:
                    return nil
                }
        }
        .asDriver(onErrorDriveWith: .empty())
        self.successSearching = self
            .searchingStatus
            .compactMap { status in
                switch status {
                case .success(payload: let payload):
                    return payload
                default:
                    return nil
                }
        }
        .asDriver(onErrorDriveWith: .empty())

        onQuery
            // skip initial BehaviorRelay value
            .skip(1)
            .flatMap { query in
                Observable.concat(
                    Observable.just(KanjiSearchStatus.loading),
                    kanjiRepository
                        .search(query: query)
                        .map {
                            if let error = KanjiSearchError.init(kanjiResults: $0) {
                                return KanjiSearchStatus.error(error: error)
                            } else {
                                return KanjiSearchStatus.success(payload: $0)
                            }
                    }
                    .asObservable()
                )
        }
        .bind(to: self.searchingStatus)
        .disposed(by: disposeBag)
    }
}
