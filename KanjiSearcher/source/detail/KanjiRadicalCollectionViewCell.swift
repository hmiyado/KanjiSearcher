//

import Foundation
import UIKit

class KanjiRadicalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var kanjiRadicalLabel: UILabel!

    func setKanjiRadical(_ kanjiRadical: KanjiRadical) {
        kanjiRadicalLabel.text = kanjiRadical.string
    }
}
