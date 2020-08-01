//

@testable import KanjiSearcher
import Nimble
import OHHTTPStubs
import Quick
import RxSwift
import RxTest

class KanjiRepositorySpec: QuickSpec {
    override func spec() {
        describe("search") {
            context("with reading") {
                let disposeBag = DisposeBag()
                it("success") {
                    //                    HTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                    //                        let url = request.mainDocumentURL?.absoluteURL
                    //                        let host = url?.host ?? ""
                    //                        let fragment = url?.fragment ?? ""
                    //                        let query = url?.query ?? ""
                    //                        return host == "mojikiban.ipa.go.jp" && fragment == "/mji/q" && query.contains("読み")
                    //                    }) { (_) -> HTTPStubsResponse in
                    //                        HTTPStubsResponse.init(jsonObject: <#T##Any#>, statusCode: <#T##Int32#>, headers: <#T##[AnyHashable : Any]?#>)
                    //                    }
                    //                    let scheduler = TestScheduler.init(initialClock: 0)
                    //                    let observer = scheduler.createObserver(KanjiResults.self)
                    //                    KanjiRepository()
                    //                        .search(query: KanjiQuery.init(reading: "つじ"))
                    //                        .subscribe(observer)
                    //                        .disposed(by: disposeBag)
                    //
                    //                    scheduler.start()
                    //                    expect(observer.events).to(equal([.next(0, KanjiResultConverter().convert())]))
                }
            }
        }
    }
}
