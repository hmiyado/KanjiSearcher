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
            context("isHiragana") {
                context("with \"ぁ\"") {
                    it("retruns true") {
                        expect(KanjiQuery.isHiragana("ぁ")).to(beTrue())
                    }
                }
                context("with \"一部ひらがな\"") {
                    it("returns false") {
                        expect(KanjiQuery.isHiragana("一部ひらがな")).to(beFalse())
                    }
                }
                context("with \"カタカナ\"") {
                    it("returns false") {
                        expect(KanjiQuery.isHiragana("カタカナ")).to(beFalse())
                    }
                }
                context("with \"abc\"") {
                    it("returns false") {
                        expect(KanjiQuery.isHiragana("abc")).to(beFalse())
                    }
                }
            }
        }
    }
}
