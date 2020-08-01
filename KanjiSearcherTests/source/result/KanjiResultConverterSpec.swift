//
@testable import KanjiSearcher
import Nimble
import Quick

class KanjiResultConverterSpec: QuickSpec {
    override func spec() {
        describe("convert") {
            context("error") {
                it("convert") {
                    let pathString = Bundle(for: type(of: self)).path(forResource: "error_invalid_parameters", ofType: "json")
                    let json = try Data(contentsOf: URL(fileURLWithPath: pathString!))

                    let result = KanjiResultConverter().convert(json)
                    expect(result).to(equal(KanjiResults.init(
                        status: .error, message: "Invalid Parameters", find: false, count: 0, results: []
                    )))
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
                    expect(result).to(equal(KanjiResults.init(status: .success, message: "", find: false, count: 0, results: [])))
                }
            }
            context("with result") {
                it("convert") {
                    let json = """
                    {
                        "status": "success",
                        "find": true,
                        "results": [
                            {
                                "MJ文字図形名": "MJ025761",
                                "戸籍統一文字番号": "437750",
                                "住基ネット統一文字コード": "J+BC2F",
                                "入管正字コード": "8FBB",
                                "入管外字コード": "",
                                "漢字施策": {
                                    "人名用漢字": true,
                                    "常用漢字": false
                                },
                                "JISX0213": {
                                    "面区点位置": "1-36-52",
                                    "水準": "1",
                                    "包摂区分": "0"
                                },
                                "UCS": {
                                    "対応するUCS": "U+8FBB",
                                    "対応カテゴリー": "A"
                                },
                                "IPAmj明朝フォント実装": {
                                    "フォントバージョン": "005.01",
                                    "実装したUCS": "U+8FBB",
                                    "実装したMoji_JohoIVS": "8FBB_E0103"
                                },
                                "MJ文字図形": {
                                    "uri": "http://mojikiban.ipa.go.jp/MJ025761.png",
                                    "MJ文字図形バージョン": "1.0"
                                },
                                "登記統一文字番号": "00437750",
                                "部首内画数": [
                                    {
                                        "部首": 162,
                                        "内画数": 2
                                    }
                                ],
                                "総画数": 6,
                                "読み": {
                                    "訓読み": [
                                        "つじ"
                                    ]
                                },
                                "大漢和": "38711",
                                "日本語漢字辞典": 12698,
                                "新大字典": 17043,
                                "大字源": 10079,
                                "大漢語林": 11460
                            },
                            {
                                "MJ文字図形名": "MJ025760",
                                "戸籍統一文字番号": "437660",
                                "住基ネット統一文字コード": "J+8FBB",
                                "入管正字コード": "",
                                "入管外字コード": "",
                                "漢字施策": {
                                    "人名用漢字": false,
                                    "常用漢字": false
                                },
                                "JISX0213": {
                                    "面区点位置": "1-36-52",
                                    "水準": "1",
                                    "包摂区分": "2",
                                    "包摂連番": [
                                        "U128"
                                    ]
                                },
                                "UCS": {
                                    "対応するUCS": "U+8FBB",
                                    "対応カテゴリー": "A"
                                },
                                "IPAmj明朝フォント実装": {
                                    "フォントバージョン": "005.01",
                                    "実装したMoji_JohoIVS": "8FBB_E0102"
                                },
                                "MJ文字図形": {
                                    "uri": "http://mojikiban.ipa.go.jp/MJ025760.png",
                                    "MJ文字図形バージョン": "1.0"
                                },
                                "登記統一文字番号": "00437660",
                                "部首内画数": [
                                    {
                                        "部首": 162,
                                        "内画数": 2
                                    }
                                ],
                                "総画数": 5,
                                "読み": {
                                    "訓読み": [
                                        "つじ"
                                    ]
                                },
                                "日本語漢字辞典": 12699,
                                "更新履歴": [
                                    {
                                        "バージョン": "005.02",
                                        "更新情報": "「大漢和」を削除"
                                    }
                                ]
                            }
                        ],
                        "count": 2
                    }
                    """.data(using: .utf8)!

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
