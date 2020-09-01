//
import Foundation
@testable import KanjiSearcher
import Nimble
import OHHTTPStubs
import Quick
import RxSwift
import RxTest

class ResultViewModelSpec: QuickSpec {

    override func spec() {
        let disposeBag = DisposeBag()
        let reader = FileReader.init()
        var scheduler: TestScheduler!
        var viewModel: ResultViewModelType!
        let kanjiRepositoryMock = KanjiRepositoryMock()
        beforeEach {
            scheduler = TestScheduler.init(initialClock: 0)
            viewModel = ResultViewModel.init(kanjiRepository: kanjiRepositoryMock, initialQuery: KanjiQuery.init(reading: nil))
        }
        describe("onQuery") {
            context("with なにもない (get no result)") {
                it("drives success") {
                    kanjiRepositoryMock.searchCondition = { _ in
                        KanjiResults.init(status: .success, message: "", count: 0, results: [])
                    }

                    scheduler
                        .createHotObservable([
                            .next(10, KanjiQuery.init(reading: "なにもない"))
                        ])
                        .bind(to: viewModel.input.onQuery)
                        .disposed(by: disposeBag)

                    let loadObserver = scheduler.createObserver(with: viewModel.output.waitSearching, disposedBy: disposeBag)
                    let successObserver = scheduler.createObserver(with: viewModel.output.successSearching, disposedBy: disposeBag)
                    let emptyObserver = scheduler.createObserver(with: viewModel.output.emptySearching, disposedBy: disposeBag)

                    scheduler.start()
                    expect(loadObserver.events.map { $0.time })
                        .to(equal([10]))
                    expect(successObserver.events)
                        .to(equal([]))
                    expect(emptyObserver.events.count)
                        .to(equal(1))
                }
                context("get error for invalid parameters") {
                    it("drives error") {
                        let errorInvalidParams = KanjiResults.init(status: .error(message: "Invalid Parameters"), message: "Invalid Parameters", count: 0, results: [])

                        kanjiRepositoryMock.searchCondition = { _ in
                            errorInvalidParams
                        }

                        scheduler
                            .createHotObservable([
                                .next(10, KanjiQuery.init())
                            ])
                            .bind(to: viewModel.input.onQuery)
                            .disposed(by: disposeBag)

                        let observer = scheduler
                            .createObserver(with: viewModel.output.errorSearching, disposedBy: disposeBag)

                        scheduler.start()
                        expect(observer.events)
                            .to(equal([
                                .next(10, KanjiSearchError.init(kanjiResults: errorInvalidParams)!)
                            ]))
                    }
                }
                context("with つじ (get 2 results)") {
                    var result: KanjiResults!
                    beforeEach {
                        result = try? KanjiResultConverter().convert(reader.readJson(fileName: "query_つじ"))
                        kanjiRepositoryMock.searchCondition = { _ in
                            result
                        }
                        scheduler
                            .createHotObservable([
                                .next(10, KanjiQuery.init(reading: "つじ"))
                            ])
                            .bind(to: viewModel.input.onQuery)
                            .disposed(by: disposeBag)
                    }
                    it("drives success") {
                        let observer = scheduler.createObserver(
                            with: viewModel.output.successSearching,
                            disposedBy: disposeBag
                        )

                        scheduler.start()
                        expect(observer.events)
                            .to(equal([
                                .next(10, result)
                            ]))
                    }
                    context("and on select 2nd item") {
                        it("showDetail of the item") {
                            scheduler
                                .createHotObservable([.next(20, IndexPath.init(row: 1, section: 0))])
                                .bind(to: viewModel.input.onSelectItem)
                                .disposed(by: disposeBag)

                            let observer = scheduler
                                .createObserver(with: viewModel.output.showDetail, disposedBy: disposeBag)

                            scheduler.start()
                            expect(observer.events)
                                .to(equal([.next(20, result.results[1])]))
                        }
                    }
                }
            }
        }
    }
}
