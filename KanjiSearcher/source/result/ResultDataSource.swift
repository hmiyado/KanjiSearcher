//

import Foundation
import UIKit

class ResultDataSource: NSObject {
    var kanjiResults: KanjiResults? = nil
}

extension ResultDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanjiResults?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "kanjiInfoListItem", for: indexPath)
        guard let cell = _cell as? ResultTableViewCell, let info = kanjiResults?.results[indexPath.row] else {
            return _cell
        }
        
        cell.setKanjiInfo(kanjiInfo: info)
       
       return cell
    }
}

