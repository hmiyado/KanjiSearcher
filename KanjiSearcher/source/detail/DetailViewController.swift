//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    private let kanjiInfo: KanjiInfo

    @IBOutlet private weak var kanjiImage: UIImageView!
    @IBOutlet private weak var onyomi: UILabel!
    @IBOutlet private weak var kunyomi: UILabel!
    @IBOutlet private weak var strokeCount: UILabel!
    @IBOutlet private weak var forPersonalName: UILabel!
    @IBOutlet private weak var forStandardUse: UILabel!

    init?(coder: NSCoder, kanjiInfo: KanjiInfo) {
        self.kanjiInfo = kanjiInfo
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.kanjiImage.image = UIImage.init(url: kanjiInfo.figure.url)
        self.onyomi.text = kanjiInfo.reading.displayedOnyomi
        self.kunyomi.text = kanjiInfo.reading.displayedKunyomi
        self.strokeCount.text = String(kanjiInfo.strokeCount)
        self.forPersonalName.isEnabled = kanjiInfo.type.forPersonalName
        self.forStandardUse.isEnabled = kanjiInfo.type.forStandardUse
    }
}
