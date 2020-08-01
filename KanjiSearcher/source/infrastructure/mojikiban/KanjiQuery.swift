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
