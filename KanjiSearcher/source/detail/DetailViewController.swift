//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    init?(coder: NSCoder, kanjiInfo: KanjiInfo) {
        print(kanjiInfo)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
