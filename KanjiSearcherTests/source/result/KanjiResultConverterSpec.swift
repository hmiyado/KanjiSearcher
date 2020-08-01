//
@testable import KanjiSearcher
import Nimble
import Quick

class KanjiResultConverterSpec: QuickSpec {
    override func spec() {
        var reader: FileReader!
        beforeEach {
            reader = FileReader()
        }
        describe("convert") {
            context("error") {
                it("convert") {
                    let json = try reader.readJson(fileName: "error_invalid_parameters")

                    let result = KanjiResultConverter().convert(json)
                    expect(result).to(equal(KanjiResults.init(
                        status: .error, message: "Invalid Parameters", find: false, count: 0, results: []
                    )))
                }
            }
            context("no result") {
                it("convert") {
                    let json = try reader.readJson(fileName: "no_results")

                    let result = KanjiResultConverter().convert(json)
                    expect(result)
                        .to(equal(KanjiResults.init(
                            status: .success,
                            message: "",
                            find: false,
                            count: 0,
                            results: [])))
                }
            }
            context("with result") {
                it("convert") {
                    let json = try reader.readJson(fileName: "query_つじ")

                    let result = KanjiResultConverter().convert(json)
                    expect(result).to(equal(KanjiResults.init(status: .success, message: "", find: true, count: 2, results: [
                        KanjiInfo.init(
                            name: "MJ025761",
                            number: 437750,
                            type: KanjiType.init(forPersonalName: true, forStandardUse: false),
                            figure: KanjiFigure.init(url: URL(string: "http://mojikiban.ipa.go.jp/MJ025761.png")!, version: "1.0"),
                            strokeCount: 6,
                            reading: KanjiReading.init(onyomi: [], kunyomi: ["つじ"])),
                        KanjiInfo.init(
                            name: "MJ025760",
                            number: 437660,
                            type: KanjiType.init(forPersonalName: false, forStandardUse: false),
                            figure: KanjiFigure.init(url: URL(string: "http://mojikiban.ipa.go.jp/MJ025760.png")!, version: "1.0"),
                            strokeCount: 5,
                            reading: KanjiReading.init(onyomi: [], kunyomi: ["つじ"]))
                    ])))
                }
            }
        }
    }
}
