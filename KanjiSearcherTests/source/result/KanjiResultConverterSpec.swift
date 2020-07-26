//
@testable import KanjiSearcher
import Nimble
import Quick

class KanjiResultConverterSpec: QuickSpec {
    override func spec() {
        describe("convert") {
            context("error") {
                it("convert") {
                    let json = """
                    {
                        "status": "error",
                        "message": "Invalid Parameters"
                    }
                    """.data(using: .utf8)!

                    let result = KanjiResultConverter().convert(json)
                    expect(result).to(beNil())
                }
            }
            context("no result") {
                it("convert") {
                    let json = """
                    {
                        "status": "success",
                        "find": false,
                        "count": 0
                    }
                    """.data(using: .utf8)!

                    let result = KanjiResultConverter().convert(json)
                    expect(result).to(equal(KanjiResults.init(status: .success, find: false, count: 0)))
                }
            }
        }
    }
}
