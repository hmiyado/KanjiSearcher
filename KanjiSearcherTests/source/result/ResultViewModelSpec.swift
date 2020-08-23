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
            context("with なにもない (get no result)") {
                it("drives success") {
                    kanjiRepositoryMock.searchCondition = { _ in
                        KanjiResults.init(status: .success, message: "", find: false, count: 0, results: [])
                    }

                    scheduler
                        .createHotObservable([
                            .next(10, KanjiQuery.init(reading: "なにもない"))
                        ])
                        .bind(to: viewModel.input.onQuery)
                        .disposed(by: disposeBag)

                    let loadObserver = scheduler.createObserver(Void.self)
                    viewModel.output.waitSearching.asObservable().subscribe(loadObserver).disposed(by: disposeBag)
                    let successObserver = scheduler.createObserver(KanjiResults.self)
                    viewModel.output.successSearching.asObservable().subscribe(successObserver).disposed(by: disposeBag)

                    scheduler.start()
                    expect(loadObserver.events.map { $0.time })
                        .to(equal([10]))
                    expect(successObserver.events)
                        .to(equal([
                            .next(10, KanjiResults.init(status: .success, message: "", find: false, count: 0, results: []))
                        ]))
                }
                context("get error for invalid parameters") {
                    it("drives error") {
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

                        let observer = scheduler.createObserver(KanjiSearchError.self)
                        viewModel.output.errorSearching.asObservable().subscribe(observer).disposed(by: disposeBag)

                        scheduler.start()
                        expect(observer.events)
                            .to(equal([
                                .next(10, KanjiSearchError.init(kanjiResults: errorInvalidParams)!)
                            ]))
                    }
                }
                context("with つじ (get 2 results)") {
                    it("drives success") {
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

                        let observer = scheduler.createObserver(KanjiResults.self)
                        viewModel.output.successSearching.asObservable().subscribe(observer).disposed(by: disposeBag)

                        scheduler.start()
                        expect(observer.events)
                            .to(equal([
                                .next(10, result)
                            ]))
                    }

                }
            }
        }
    }
}
