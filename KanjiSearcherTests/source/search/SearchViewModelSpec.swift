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
        var viewModel: SearchViewModel!
        beforeEach {
            scheduler = TestScheduler.init(initialClock: 0)
            viewModel = SearchViewModel.init()
        }
        describe("search") {
            context("with no QueryReading") {
                it("onSearch") {
                    scheduler
                        .createHotObservable([.next(10, ())])
                        .bind(to: viewModel.onSearch)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(KanjiQuery.self)
                    viewModel.search.drive(observer).disposed(by: disposeBag)

                    scheduler.start()

                    expect(observer.events)
                        .to(equal([]))
                }
            }
            context("with QeuryReading") {
                beforeEach {
                    scheduler
                        .createHotObservable([.next(10, "query")])
                        .bind(to: viewModel.onQueryReading)
                        .disposed(by: disposeBag)
                }
                it("onSearch") {
                    scheduler
                        .createHotObservable([.next(20, ())])
                        .bind(to: viewModel.onSearch)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(KanjiQuery.self)
                    viewModel.search.drive(observer).disposed(by: disposeBag)

                    scheduler.start()

                    expect(observer.events)
                        .to(equal([.next(20, KanjiQuery.init(reading: "query"))]))

                }
            }
        }
    }
}
