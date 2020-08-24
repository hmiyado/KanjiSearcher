//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet private weak var onyomi: UILabel!
    @IBOutlet private weak var kunyomi: UILabel!
    @IBOutlet private weak var strokeCount: UILabel!
    @IBOutlet private weak var kanjiImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setKanjiInfo(kanjiInfo: KanjiInfo) {
        onyomi.text = kanjiInfo.reading.onyomi.asDisplayedString()
        kunyomi.text = kanjiInfo.reading.kunyomi.asDisplayedString()
        strokeCount.text = String(kanjiInfo.strokeCount)
        kanjiImage.image = UIImage.init(url: kanjiInfo.figure.url)
    }
}

extension KanjiReading {
    var displayedOnyomi: String {
        onyomi.asDisplayedString()
    }

    var displayedKunyomi: String {
        kunyomi.asDisplayedString()
    }
}

private extension Array where Element == String {

    func asDisplayedString() -> String {
        if count == 0 {
            return "--"
        } else {
            return joined(separator: "/")
        }
    }
}
