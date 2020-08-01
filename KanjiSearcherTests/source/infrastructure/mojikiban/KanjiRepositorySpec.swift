//

@testable import KanjiSearcher
import Nimble
import OHHTTPStubs
import Quick
import RxBlocking
import RxSwift
import RxTest

class KanjiRepositorySpec: QuickSpec {
    override func spec() {
        let reader = FileReader()
        describe("search") {
            context("with reading") {
                it("success") {
                    let json = try reader.readJson(fileName: "query_つじ")
                    HTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                        let url = request.url
                        let host = url?.host ?? ""
                        let path = url?.path ?? ""
                        let query = url?.query ?? ""

                        return host == "mojikiban.ipa.go.jp"
                            && path == "/mji/q"
                            && query.contains("読み".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    }, withStubResponse: { (_) -> HTTPStubsResponse in
                        HTTPStubsResponse.init(data: json, statusCode: 200, headers: nil)
                    })

                    let observable = KanjiRepository()
                        .search(query: KanjiQuery.init(reading: "つじ"))
                        .toBlocking()

                    expect(try observable.toArray()).to(equal([KanjiResultConverter().convert(json)]))
                }
            }
            context("with no query") {
                it("error") {
                    let json = try reader.readJson(fileName: "error_empty_query")
                    HTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                        let url = request.url
                        let host = url?.host ?? ""
                        let path = url?.path ?? ""
                        let query = url?.query ?? ""

                        return host == "mojikiban.ipa.go.jp"
                            && path == "/mji/q"
                            && query == ""
                    }, withStubResponse: { (_) -> HTTPStubsResponse in
                        HTTPStubsResponse.init(data: json, statusCode: 200, headers: nil)
                    })

                    let observable = KanjiRepository()
                        .search(query: KanjiQuery.init())
                        .toBlocking()

                    expect(try observable.first()).to(equal(KanjiResultConverter().convert(json)))
                }
            }
        }
    }
}
