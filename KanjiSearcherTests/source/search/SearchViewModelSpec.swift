//
@testable import KanjiSearcher
import Nimble
import Quick
import RxSwift
import RxTest

class SearchViewModelSpec: QuickSpec {
    override func spec() {
        let disposeBag = DisposeBag()
        var scheduler: TestScheduler!
        var viewModel: SearchViewModelType!
        beforeEach {
            scheduler = TestScheduler.init(initialClock: 0)
            viewModel = SearchViewModel.init()
        }
        describe("search") {
            context("with no QueryReading") {
                it("onSearch") {
                    scheduler
                        .createHotObservable([.next(10, ())])
                        .bind(to: viewModel.input.onSearch)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(KanjiQuery.self)
                    viewModel.output.search.drive(observer).disposed(by: disposeBag)

                    scheduler.start()

                    expect(observer.events)
                        .to(equal([]))
                }
                context("isSearchable") {
                    it("should be false") {
                        let observer = scheduler.createObserver(Bool.self)
                        viewModel.output.isSearchable.drive(observer).disposed(by: disposeBag)

                        scheduler.start()

                        expect(observer.events).to(equal([.next(0, false)]))
                    }

                }
            }
            context("with QeuryReading") {
                beforeEach {
                    scheduler
                        .createHotObservable([.next(10, "よみ")])
                        .bind(to: viewModel.input.onQueryReading)
                        .disposed(by: disposeBag)
                }
                context("isSearchable") {
                    it("should be true") {
                        let observer = scheduler.createObserver(Bool.self)
                        viewModel.output.isSearchable.drive(observer).disposed(by: disposeBag)

                        scheduler.start()

                        expect(observer.events)
                            .to(contain([.next(10, true)]))
                    }
                }
                it("onSearch") {
                    scheduler
                        .createHotObservable([.next(20, ())])
                        .bind(to: viewModel.input.onSearch)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(KanjiQuery.self)
                    viewModel.output.search.drive(observer).disposed(by: disposeBag)

                    scheduler.start()

                    expect(observer.events)
                        .to(equal([.next(20, KanjiQuery.init(reading: "よみ"))]))

                }
            }
        }
    }
}
