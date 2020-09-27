//

import Foundation
import UIKit

class ResultErrorView: UIView {

    @IBOutlet private weak var errorDetailLabel: UILabel!
    override var intrinsicContentSize: CGSize {
        return subviews.first?.frame.size ?? super.intrinsicContentSize
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }

    private func loadNib() {
        let nib = UINib(nibName: "ResultErrorView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addSubview(view)
    }

    func showError(_ error: KanjiResultsError) {
        switch error {
        case .invalidParameters:
            self.errorDetailLabel.text = "不正な検索です。検索の内容を変えて再度検索してください。"
        case .emptyQuery:
            self.errorDetailLabel.text = "検索語句がありません。検索語句を入力して再度検索してください。"
        case .unknown:
            self.errorDetailLabel.text = "エラーが発生しました。再度検索してください。"
        }
    }
}
