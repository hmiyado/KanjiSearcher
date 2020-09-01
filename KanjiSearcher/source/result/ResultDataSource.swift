//

import Foundation
import UIKit

class ResultDataSource: NSObject {
    var kanjiResults: KanjiResults?
}

extension ResultDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kanjiResults?.status {
        case .success(let count):
            return count
        case .error:
            return 0
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOptional = tableView.dequeueReusableCell(withIdentifier: "kanjiInfoListItem", for: indexPath)
        guard let cell = cellOptional as? ResultTableViewCell, let info = kanjiResults?.results[indexPath.row] else {
            return cellOptional
        }

        cell.setKanjiInfo(kanjiInfo: info)

        return cell
    }
}
