//

import Foundation
import UIKit

class ResultDataSource: NSObject {
    var results: [KanjiInfo] = []
}

extension ResultDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOptional = tableView.dequeueReusableCell(withIdentifier: "kanjiInfoListItem", for: indexPath)
        guard let cell = cellOptional as? ResultTableViewCell else {
            return cellOptional
        }
        cell.setKanjiInfo(kanjiInfo: results[indexPath.row])

        return cell
    }
}
