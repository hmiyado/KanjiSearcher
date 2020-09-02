//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol ResultViewModelInput {
    var onQuery: BehaviorRelay<KanjiQuery> { get }
    var onSelectItem: PublishRelay<IndexPath> { get }
}

protocol ResultViewModelOutput {
    var waitSearching: Driver<Void> {get}
    var successSearching: Driver<[KanjiInfo]> { get }
    var errorSearching: Driver<KanjiResultsError> { get }
    var emptySearching: Driver<Void> { get }
    var showDetail: Driver<KanjiInfo> {get}
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
    let onQuery: BehaviorRelay<KanjiQuery>
    let onSelectItem: PublishRelay<IndexPath> = PublishRelay.init()

    // MARK: ResultViewModelOutput
    let waitSearching: Driver<Void>
    let successSearching: Driver<[KanjiInfo]>
    let errorSearching: Driver<KanjiResultsError>
    let emptySearching: Driver<Void>
    let showDetail: Driver<KanjiInfo>

    // MARK: properties
    private let kanjiRepository: KanjiRepositoryProtocol
    private let disposeBag = DisposeBag()

    private let searchingStatus: PublishRelay<KanjiSearchStatus> = PublishRelay.init()

    init(kanjiRepository: KanjiRepositoryProtocol, initialQuery: KanjiQuery) {
        self.kanjiRepository = kanjiRepository
        self.onQuery = BehaviorRelay.init(value: initialQuery)
        self.waitSearching = self.searchingStatus
            .filter { $0 == .loading }
            .map { _ in  () }
            .asDriver(onErrorDriveWith: .empty())
        self.errorSearching = self.searchingStatus
            .compactMap { status in
                switch status {
                case .error(detail: let error):
                    return error
                default:
                    return nil
                }
        }
        .asDriver(onErrorDriveWith: .empty())
        let success: Observable<[KanjiInfo]> = self.searchingStatus
            .compactMap { status in
                switch status {
                case .success(payload: let payload):
                    switch payload {
                    case let .success(_, results):
                        return results
                    default:
                        return nil
                    }
                default:
                    return nil
                }
        }
        self.successSearching = success
            .filter { !$0.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
        self.emptySearching = success
            .filter { $0.isEmpty }
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        self.showDetail = self.onSelectItem
            .withLatestFrom(self.successSearching) { indexPath, results in
                results[indexPath.row]
        }
        .compactMap { $0 }
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
                            switch $0 {
                            case .success:
                                return KanjiSearchStatus.success(payload: $0)
                            case let .error(detail):
                                return KanjiSearchStatus.error(detail: detail)
                            }
                    }
                    .asObservable()
                )
        }
        .bind(to: self.searchingStatus)
        .disposed(by: disposeBag)
    }
}
