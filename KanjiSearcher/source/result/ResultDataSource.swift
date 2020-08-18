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
       // Fetch a cell of the appropriate type.
       let cell = UITableViewCell()
       
       // Configure the cell’s contents.
        cell.textLabel!.text = kanjiResults?.results[indexPath.row].name ?? ""
           
       return cell
    }
}
