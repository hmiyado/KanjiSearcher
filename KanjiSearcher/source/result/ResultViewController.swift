//

import UIKit

class ResultViewController: UIViewController {
    private let viewModel: ResultViewModelType = ResultViewModel.init(kanjiRepository: KanjiRepository())
    var query: KanjiQuery {
        get { viewModel.input.onQuery.value }
        set(value) { viewModel.input.onQuery.accept(value) }
    }

    override func viewDidLoad() {
        print(query ?? "no query")
    }
}
