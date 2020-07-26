//

import Foundation

struct KanjiInfo: Decodable {
    /// MJ図形名
    var name: String
    /// 戸籍統一文字番号
    var number: Int
    var type: KanjiType
    var figure: KanjiFigure
    /// 総画数
    var strokeCount: Int
    var reading: KanjiReading

    enum CodingKeys: String, CodingKey {
        case name = "MJ図形名"
        case number = "戸籍統一文字番号"
        case type = "漢字施策"
        case figure = "MJ文字図形"
        case strokeCount = "総画数"
        case reading = "読み"
    }
}

/// 漢字施策
struct KanjiType: Decodable {
    /// 人名用漢字
    var forPersonalName: Bool
    /// 常用漢字
    var forStandardUse: Bool

    enum CodingKeys: String, CodingKey {
        case forPersonalName = "人名用漢字"
        case forStandardUse = "常用漢字"
    }
}

/// MJ文字図形
struct KanjiFigure: Decodable {
    var uri: URL
    /// MJ文字図形バージョン
    var version: String
}

/// 読み
struct KanjiReading: Decodable {
    /// 音読み
    var onyomi: [String]
    /// 訓読み
    var kunyomi: [String]
}
