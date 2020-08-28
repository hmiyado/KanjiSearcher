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
                context("query is つじ") {
                    it("convert") {
                        let json = try reader.readJson(fileName: "query_つじ")

                        let result = KanjiResultConverter().convert(json)
                        expect(result).to(equal(KanjiResults.init(status: .success, message: "", find: true, count: 2, results: [
                            KanjiInfo.init(
                                kanjiId: KanjiId(fullId: "MJ025761"),
                                idInFamilyRegister: 437750,
                                idInBasicResidentRegister: "J+BC2F",
                                domesticKanjiIdInImmigrationBreau: "8FBB",
                                foreignKanjiIdInImmigrationBreau: nil,
                                type: KanjiType.init(forPersonalName: true, forStandardUse: false),
                                figure: KanjiFigure.init(url: URL(string: "http://mojikiban.ipa.go.jp/MJ025761.png")!, version: "1.0"),
                                kanjiRadicals: [
                                    KanjiRadical.init(radicalId: 162, strokeCount: 2)],
                                strokeCount: 6,
                                reading: KanjiReading.init(onyomi: [], kunyomi: ["つじ"])),
                            KanjiInfo.init(
                                kanjiId: KanjiId(fullId: "MJ025760"),
                                idInFamilyRegister: 437660,
                                idInBasicResidentRegister: "J+8FBB",
                                domesticKanjiIdInImmigrationBreau: nil,
                                foreignKanjiIdInImmigrationBreau: nil,
                                type: KanjiType.init(forPersonalName: false, forStandardUse: false),
                                figure: KanjiFigure.init(url: URL(string: "http://mojikiban.ipa.go.jp/MJ025760.png")!, version: "1.0"),
                                kanjiRadicals: [
                                    KanjiRadical.init(radicalId: 162, strokeCount: 2)
                                ],
                                strokeCount: 5,
                                reading: KanjiReading.init(onyomi: [], kunyomi: ["つじ"]))
                        ])))
                    }
                }
                context("query is MJ004251 (with empty number)") {
                    it("convert") {
                        let json = try reader.readJson(fileName: "query_MJ文字図形名_MJ004251")

                        let result = KanjiResultConverter().convert(json)
                        expect(result).to(equal(KanjiResults.init(status: .success, message: "", find: true, count: 1, results: [
                            KanjiInfo.init(
                                kanjiId: KanjiId(fullId: "MJ004251"),
                                idInFamilyRegister: nil,
                                idInBasicResidentRegister: "J+458D",
                                domesticKanjiIdInImmigrationBreau: nil,
                                foreignKanjiIdInImmigrationBreau: nil,
                                type: KanjiType.init(forPersonalName: false, forStandardUse: false),
                                figure: KanjiFigure.init(url: URL(string: "http://mojikiban.ipa.go.jp/MJ004251.png")!, version: "1.0"),
                                kanjiRadicals: [
                                    KanjiRadical.init(radicalId: 141, strokeCount: 4)
                                ],
                                strokeCount: 10,
                                reading: KanjiReading.init(onyomi: ["ケン"], kunyomi: ["つつしむ"]))
                        ])))
                    }
                }
                context("query is MJ013503 (with 2 kanji radicals)") {
                    it("convert") {
                        let json = try reader.readJson(fileName: "query_MJ文字図形名_MJ013503")
                        let result = KanjiResultConverter().convert(json)
                        expect(result)
                            .to(equal(KanjiResults.init(status: .success, message: "", find: true, count: 1, results: [
                                KanjiInfo.init(
                                    kanjiId: KanjiId(fullId: "MJ013503"),
                                    idInFamilyRegister: nil,
                                    idInBasicResidentRegister: "J+B2A9",
                                    domesticKanjiIdInImmigrationBreau: "66FE",
                                    foreignKanjiIdInImmigrationBreau: nil,
                                    type: KanjiType.init(forPersonalName: false, forStandardUse: false),
                                    figure: KanjiFigure.init(url: URL(string: "http://mojikiban.ipa.go.jp/MJ013503.png")!, version: "1.0"),
                                    kanjiRadicals: [KanjiRadical.init(radicalId: 72, strokeCount: 8), KanjiRadical.init(radicalId: 73, strokeCount: 8)],
                                    strokeCount: 12,
                                    reading: KanjiReading.init(
                                        onyomi: ["ソ", "ソウ", "ゾ"],
                                        kunyomi: ["かつて", "すなわち"]))
                            ])))
                    }
                }
                context("query is MJ009387 (with kanji radical that has no stroke)") {
                    it("convert") {
                        let json = try reader.readJson(fileName: "query_MJ文字図形名_MJ009387")
                        let result = KanjiResultConverter().convert(json)
                        expect(result)
                            .to(equal(KanjiResults.init(status: .success, message: "", find: true, count: 1, results: [
                                KanjiInfo.init(
                                    kanjiId: KanjiId(fullId: "MJ009387"),
                                    idInFamilyRegister: 064630,
                                    idInBasicResidentRegister: "J+58F0",
                                    domesticKanjiIdInImmigrationBreau: "58F0",
                                    foreignKanjiIdInImmigrationBreau: nil,
                                    type: KanjiType.init(forPersonalName: true, forStandardUse: true),
                                    figure: KanjiFigure.init(url: URL(string: "http://mojikiban.ipa.go.jp/MJ009387.png")!, version: "1.0"),
                                    kanjiRadicals: [KanjiRadical.init(radicalId: 33, strokeCount: 4), KanjiRadical.init(radicalId: 128, strokeCount: 0)],
                                    strokeCount: 7,
                                    reading: KanjiReading.init(
                                        onyomi: [                    "セイ", "ショウ", "ケイ"],
                                        kunyomi: ["こえ", "こわ"]))
                            ])))

                    }
                }
            }
        }
    }
}
