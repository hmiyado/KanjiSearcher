//

import UIKit

class ResultViewController: UIViewController {
    var query: String!

    override func viewDidLoad() {
        print(query ?? "no query")
    }
}
