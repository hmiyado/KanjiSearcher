//

import Foundation

struct KanjiQuery {
    var reading: String?

    /// https://mojikiban.ipa.go.jp/mji/
    func asUrl() -> URL {
        var urlComponents = URLComponents(string: "https://mojikiban.ipa.go.jp/mji/q")
        urlComponents?.queryItems = [
            (reading != nil ? URLQueryItem(name: "読み", value: reading) : nil)
            ].compactMap { $0 }

        return (urlComponents?.url!)!
    }
}

extension KanjiQuery: Equatable {

}

extension KanjiQuery {
    /// defined in https://mojikiban.ipa.go.jp/mji/mji.00501.schema.json as ひらがな
    private static let hiraganaPattern = try? NSRegularExpression(pattern: "^[ぁ-ゖ゙-ゟー]*$")
    /// defined in https://mojikiban.ipa.go.jp/mji/mji.00501.schema.json as カタカナ
    private static let katakanaPattern = try? NSRegularExpression(pattern: "^[゠-ヿ]*$")

    private static func matches(to string: String, with pattern: NSRegularExpression?) -> Bool {
        guard let regex = pattern else { return false }
        let results = regex.matches(in: string, range: NSRange(location: 0, length: string.count))
        return results.count > 0
    }

    static func isHiragana(_ string: String) -> Bool {
        matches(to: string, with: hiraganaPattern)
    }

    static func isKatakana(_ string: String) -> Bool {
        matches(to: string, with: katakanaPattern)
    }
}
