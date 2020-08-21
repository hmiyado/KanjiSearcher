//

import Foundation

struct KanjiInfo: Equatable {
    /// MJ文字図形名
    var kanjiId: String
    /// 戸籍統一文字番号
    var idInKanjiSetUsableInFamilyRegister: Int?
    var type: KanjiType
    var figure: KanjiFigure
    /// 総画数
    var strokeCount: Int
    var reading: KanjiReading
}

extension KanjiInfo: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kanjiId = try values.decode(String.self, forKey: .kanjiId)
        if let number = try? values.decode(String.self, forKey: .idInKanjiSetUsableInFamilyRegister), !number.isEmpty {
            self.idInKanjiSetUsableInFamilyRegister = Int(number)
        } else {
            self.idInKanjiSetUsableInFamilyRegister = nil
        }
        strokeCount = try values.decode(Int.self, forKey: .strokeCount)
        type = try values.decode(KanjiType.self, forKey: .type)
        figure = try values.decode(KanjiFigure.self, forKey: .figure)
        reading = try values.decode(KanjiReading.self, forKey: .reading)
    }

    enum CodingKeys: String, CodingKey {
        case kanjiId = "MJ文字図形名"
        case idInKanjiSetUsableInFamilyRegister = "戸籍統一文字番号"
        case type = "漢字施策"
        case figure = "MJ文字図形"
        case strokeCount = "総画数"
        case reading = "読み"
    }

}

/// 漢字施策
struct KanjiType: Decodable, Equatable {
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
struct KanjiFigure: Decodable, Equatable {
    var url: URL
    var version: String

    enum CodingKeys: String, CodingKey {
        case url = "uri"
        case version = "MJ文字図形バージョン"
    }
}

/// 読み
struct KanjiReading: Equatable {
    /// 音読み
    var onyomi: [String]
    /// 訓読み
    var kunyomi: [String]
}

extension KanjiReading: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onyomi = (try? container.decode(Array<String>.self, forKey: .onyomi)) ?? []
        kunyomi = (try? container.decode(Array<String>.self, forKey: .kunyomi)) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case onyomi = "音読み"
        case kunyomi = "訓読み"
    }
}
