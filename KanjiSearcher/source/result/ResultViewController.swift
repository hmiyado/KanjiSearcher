//

import UIKit

class ResultViewController: UIViewController {
    var query: KanjiQuery!

    override func viewDidLoad() {
        print(query ?? "no query")
    }
}
