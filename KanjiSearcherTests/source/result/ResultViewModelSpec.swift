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
            viewModel = ResultViewModel.init(kanjiRepository: kanjiRepositoryMock)
        }
        describe("onQuery") {
            context("with reading") {
                it("get no result") {
                    kanjiRepositoryMock.searchCondition = { _ in
                        KanjiResults.init(status: .success, message: "", find: false, count: 0, results: [])
                    }

                    scheduler
                        .createHotObservable([
                            .next(10, KanjiQuery.init(reading: "なにもない"))
                        ])
                        .bind(to: viewModel.input.onQuery)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(KanjiSearchStatus.self)
                    viewModel.output.searchStatus.asObservable().subscribe(observer).disposed(by: disposeBag)

                    scheduler.start()
                    expect(observer.events)
                        .to(equal([
                            .next(10, KanjiSearchStatus.loading),
                            .next(10, KanjiSearchStatus.success(payload: KanjiResults.init(status: .success, message: "", find: false, count: 0, results: [])))
                        ]))
                }
                it("get error for invalid parameters") {
                    let errorInvalidParams = KanjiResults.init(status: .error, message: "Invalid Parameters", find: false, count: 0, results: [])

                    kanjiRepositoryMock.searchCondition = { _ in
                        errorInvalidParams
                    }

                    scheduler
                        .createHotObservable([
                            .next(10, KanjiQuery.init())
                        ])
                        .bind(to: viewModel.input.onQuery)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(KanjiSearchStatus.self)
                    viewModel.output.searchStatus.asObservable().subscribe(observer).disposed(by: disposeBag)

                    scheduler.start()
                    expect(observer.events)
                        .to(equal([
                            .next(10, KanjiSearchStatus.loading),
                            .next(10, KanjiSearchStatus.error(error: KanjiSearchError.init(kanjiResults: errorInvalidParams)!))
                        ]))
                }
                context("query つじ") {
                    it("get 2 results") {
                        let result = try KanjiResultConverter().convert(reader.readJson(fileName: "query_つじ"))
                        kanjiRepositoryMock.searchCondition = { _ in
                            result
                        }
                        scheduler
                            .createHotObservable([
                                .next(10, KanjiQuery.init(reading: "つじ"))
                            ])
                            .bind(to: viewModel.input.onQuery)
                            .disposed(by: disposeBag)

                        let observer = scheduler.createObserver(KanjiSearchStatus.self)
                        viewModel.output.searchStatus.asObservable().subscribe(observer).disposed(by: disposeBag)

                        scheduler.start()
                        expect(observer.events)
                            .to(equal([
                                .next(10, KanjiSearchStatus.loading),
                                .next(10, KanjiSearchStatus.success(payload: result))
                            ]))
                    }

                }
            }
        }
    }
}
