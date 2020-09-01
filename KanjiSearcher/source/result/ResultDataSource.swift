//

import Foundation
import UIKit

class ResultDataSource: NSObject {
    var kanjiResults: KanjiResults?
}

extension ResultDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kanjiResults?.status {
        case let .success(count, _):
            return count
        case .error:
            return 0
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOptional = tableView.dequeueReusableCell(withIdentifier: "kanjiInfoListItem", for: indexPath)
        guard let cell = cellOptional as? ResultTableViewCell else {
            return cellOptional
        }
        switch kanjiResults?.status {
        case .success(_, let results):
            cell.setKanjiInfo(kanjiInfo: results[indexPath.row])
        default:
            break
        }

        return cell
    }
}
