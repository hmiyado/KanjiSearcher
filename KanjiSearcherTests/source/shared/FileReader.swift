//

import Foundation

class FileReader {
    func readJson(fileName: String) throws -> Data {
        let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json")
        return try Data(contentsOf: URL(fileURLWithPath: pathString!))
    }
}
