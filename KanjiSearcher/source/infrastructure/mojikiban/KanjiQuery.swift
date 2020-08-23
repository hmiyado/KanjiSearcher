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
    private static let hiraganaPattern = "^[ぁ-ゖ゙-ゟー]*$"

    static func isHiragana(_ string: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: hiraganaPattern) else { return false }
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.count))
        return matches.count > 0
    }
}
