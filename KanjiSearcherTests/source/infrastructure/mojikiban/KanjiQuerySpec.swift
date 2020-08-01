//

@testable import KanjiSearcher
import Nimble
import Quick

class KanjiQuerySpec: QuickSpec {
    override func spec() {
        describe("KanjiQuery") {
            context("with reading") {
                let query = KanjiQuery.init(reading: "あ")
                it("asUrl") {
                    expect(query.asUrl())
                        .to(equal(URL
                            .init(string: "https://mojikiban.ipa.go.jp/mji/q?読み=あ"
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        )))
                }
            }
            context("with no parameters") {
                let query = KanjiQuery.init()
                context("asUrl") {
                    it("returns URL without query") {
                        expect(query.asUrl())
                            .to(equal(URL.init(string: "https://mojikiban.ipa.go.jp/mji/q?")))
                    }
                }
            }
        }
    }
}
