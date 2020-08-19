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
        let cell = tableView.dequeueReusableCell(withIdentifier: "kanjiInfoListItem", for: indexPath)
       
       return cell
    }
}

