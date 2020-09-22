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
            // resolution converts 1 [clock] to 1 [milliseconds]
            scheduler = TestScheduler.init(initialClock: 0, resolution: 0.001)
            viewModel = SearchViewModel.init(scheduler: scheduler)
        }
        describe("search") {
            context("with no QueryReading") {
                it("onSearch") {
                    scheduler
                        .createHotObservable([.next(10, ())])
                        .bind(to: viewModel.input.onSearch)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(with: viewModel.output.search, disposedBy: disposeBag)

                    scheduler.start()

                    expect(observer.events)
                        .to(equal([]))
                }
                context("isSearchable") {
                    it("should be false") {
                        let observer = scheduler.createObserver(with: viewModel.output.isSearchable, disposedBy: disposeBag)

                        scheduler.start()

                        expect(observer.events).to(equal([.next(0, false)]))
                    }
                }
                context("onEndEditing") {
                    it("do not search") {
                        scheduler
                            .createHotObservable([.next(10, ())])
                            .bind(to: viewModel.input.onEndEditing)
                            .disposed(by: disposeBag)

                        let observer = scheduler.createObserver(with: viewModel.output.search, disposedBy: disposeBag)

                        scheduler.start()

                        expect(observer.events)
                            .to(equal([]))

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
                        let observer = scheduler.createObserver(with: viewModel.output.isSearchable, disposedBy: disposeBag)

                        scheduler.start()

                        expect(observer.events)
                            .to(contain([.next(10, true)]))
                    }
                }
                context("onEndEditing") {
                    it("search") {
                        scheduler
                            .createHotObservable([.next(20, ())])
                            .bind(to: viewModel.input.onEndEditing)
                            .disposed(by: disposeBag)
                        let observer = scheduler.createObserver(with: viewModel.output.search, disposedBy: disposeBag)

                        scheduler.start()

                        expect(observer.events)
                            .to(equal([.next(20, KanjiQuery.init(reading: "よみ"))]))
                    }
                }
                it("onSearch") {
                    scheduler
                        .createHotObservable([.next(20, ())])
                        .bind(to: viewModel.input.onSearch)
                        .disposed(by: disposeBag)

                    let observer = scheduler.createObserver(with: viewModel.output.search, disposedBy: disposeBag)

                    scheduler.start()

                    expect(observer.events)
                        .to(equal([.next(20, KanjiQuery.init(reading: "よみ"))]))
                }
                describe("search") {
                    context("multiple times in short time") {
                        it("do once") {
                            scheduler
                                .createHotObservable([.next(20, ())])
                                .bind(to: viewModel.input.onSearch)
                                .disposed(by: disposeBag)
                            scheduler
                                .createHotObservable([.next(30, ())])
                                .bind(to: viewModel.input.onEndEditing)
                                .disposed(by: disposeBag)

                            let observer = scheduler.createObserver(with: viewModel.output.search, disposedBy: disposeBag)

                            scheduler.start()

                            expect(observer.events)
                                .to(equal([.next(20, KanjiQuery.init(reading: "よみ"))]))
                        }
                    }
                }
            }
        }
    }
}
