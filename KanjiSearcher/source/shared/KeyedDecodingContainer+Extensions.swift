//

import Foundation

extension KeyedDecodingContainer {
    func decodeArray<T>(forKey key: Self.Key) throws -> [T] where T: Decodable {
        guard var container = try? nestedUnkeyedContainer(forKey: key) else {
            return []
        }
        var temp: [T] = []
        while !container.isAtEnd {
            let decoder = try container.superDecoder()
            let item = try T.init(from: decoder)
            temp.append(item)
        }
        return temp
    }
}
