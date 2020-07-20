//

import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController {

    // MARK: property
    let viewModel = SearchViewModel.init()
    let disposeBag = DisposeBag()

    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var textFieldReading: UITextField!

    // MARK: method

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonSearch.rx.tap
            .bind(to: viewModel.input.onSearch)
            .disposed(by: disposeBag)
        textFieldReading.rx.text
            .map { query in query ?? "" }
            .bind(to: viewModel.input.onQueryReading)
            .disposed(by: disposeBag)
    }
}
