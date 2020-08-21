//

import Foundation
import UIKit

class ResultDataSource: NSObject {
    var kanjiResults: KanjiResults?
}

extension ResultDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanjiResults?.count ?? 0
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
