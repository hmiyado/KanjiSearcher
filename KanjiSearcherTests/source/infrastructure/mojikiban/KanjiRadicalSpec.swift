//

import Foundation
@testable import KanjiSearcher
import Nimble
import Quick

class KanjiRadicalSpec: QuickSpec {
    override func spec() {
        describe("character") {
            context("radical id = 1") {
                it("should be ⼀ (Unicode 2F00)") {
                    let actual = KanjiRadical.init(radicalId: 1, strokeCount: 1)
                    expect(actual.string)
                        .to(equal("⼀"))
                }
            }
            context("radical id = 214") {
                it("should be ⿕ (Unicode 2FD5)") {
                    expect(KanjiRadical.init(radicalId: 214, strokeCount: 0).string)
                        .to(equal("⿕"))
                }
            }
        }
    }
}
