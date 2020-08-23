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
            context("isValidReading") {
                context("with \"\"") {
                    it("returns false") {
                        expect(KanjiQuery.isValidReading("")).to(beFalse())
                    }
                }
                context("with \"ぁ\"") {
                    it("retruns true") {
                        expect(KanjiQuery.isValidReading("ぁ")).to(beTrue())
                    }
                }
                context("with \"一部ひらがな\"") {
                    it("returns false") {
                        expect(KanjiQuery.isValidReading("一部ひらがな")).to(beFalse())
                    }
                }
                context("with \"カタカナ\"") {
                    it("returns true") {
                        expect(KanjiQuery.isValidReading("カタカナ")).to(beTrue())
                    }
                }
                context("with \"カタカナとひらがな\"") {
                    // This case is valid in API spec.
                    // However, this query returns no result.
                    it("returns true") {
                        expect(KanjiQuery.isValidReading("カタカナとひらがな")).to(beTrue())
                    }
                }
                context("with \"abc\"") {
                    it("returns false") {
                        expect(KanjiQuery.isValidReading("abc")).to(beFalse())
                    }
                }
            }
        }
    }
}
