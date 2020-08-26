//

import Foundation
import UIKit

class KanjiRadicalsDataSource: NSObject {
    let kanjiRadicals: [KanjiRadical]

    init(kanjiRadicals: [KanjiRadical]) {
        self.kanjiRadicals = kanjiRadicals
        super.init()
    }

    override init() {
        fatalError()
    }
}

extension KanjiRadicalsDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        kanjiRadicals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellOptional = collectionView.dequeueReusableCell(withReuseIdentifier: "kanjiRadicalListItem", for: indexPath)
        guard let cell = cellOptional as? KanjiRadicalCollectionViewCell  else {
            return cellOptional
        }
        let kanjiRadical = kanjiRadicals[indexPath.row]
        cell.setKanjiRadical(kanjiRadical)
        return cell
    }
}
