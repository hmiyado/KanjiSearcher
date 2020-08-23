//

import Foundation

struct KanjiInfo: Equatable {
    let kanjiId: KanjiId
    /// 戸籍統一文字番号
    let idInFamilyRegister: Int?
    /// 住基ネット統一文字コード
    let idInBasicResidentRegister: String?
    /// 入管正字コード
    let domesticKanjiIdInImmigrationBreau: String?
    let type: KanjiType
    let figure: KanjiFigure
    /// 総画数
    let strokeCount: Int
    let reading: KanjiReading
}

extension KanjiInfo: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        func decodeOrNilForEmptyString(forKey: CodingKeys) -> String? {
            if let string = try? values.decode(String.self, forKey: forKey), !string.isEmpty {
                return string
            } else {
                return nil
            }
        }

        kanjiId = KanjiId(fullId: try values.decode(String.self, forKey: .kanjiId))
        if let number = decodeOrNilForEmptyString(forKey: .idInFamilyRegister) {
            self.idInFamilyRegister = Int(number)
        } else {
            self.idInFamilyRegister = nil
        }
        idInBasicResidentRegister = decodeOrNilForEmptyString(forKey: .idInBasicResidentRegister)
        domesticKanjiIdInImmigrationBreau = decodeOrNilForEmptyString(forKey: .domesticKanjiId)
        strokeCount = try values.decode(Int.self, forKey: .strokeCount)
        type = try values.decode(KanjiType.self, forKey: .type)
        figure = try values.decode(KanjiFigure.self, forKey: .figure)
        reading = try values.decode(KanjiReading.self, forKey: .reading)
    }

    enum CodingKeys: String, CodingKey {
        case kanjiId = "MJ文字図形名"
        case idInFamilyRegister = "戸籍統一文字番号"
        case idInBasicResidentRegister = "住基ネット統一文字コード"
        case domesticKanjiId = "入管正字コード"
        case type = "漢字施策"
        case figure = "MJ文字図形"
        case strokeCount = "総画数"
        case reading = "読み"
    }

}

/// 漢字施策
struct KanjiType: Decodable, Equatable {
    /// 人名用漢字
    let forPersonalName: Bool
    /// 常用漢字
    let forStandardUse: Bool

    enum CodingKeys: String, CodingKey {
        case forPersonalName = "人名用漢字"
        case forStandardUse = "常用漢字"
    }
}

/// MJ文字図形
struct KanjiFigure: Decodable, Equatable {
    let url: URL
    let version: String

    enum CodingKeys: String, CodingKey {
        case url = "uri"
        case version = "MJ文字図形バージョン"
    }
}

/// 読み
struct KanjiReading: Equatable {
    /// 音読み
    let onyomi: [String]
    /// 訓読み
    let kunyomi: [String]
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
