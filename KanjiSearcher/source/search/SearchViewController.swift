//

import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController {

    // MARK: property
    let viewModel: SearchViewModelType = SearchViewModel.init()
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
        textFieldReading.rx.controlEvent(.editingDidEnd)
            .bind(to: viewModel.input.onEndEditing)
            .disposed(by: disposeBag)

        viewModel.output.search
            .drive(onNext: { [weak self] query in
                self?.performSegue(withIdentifier: "showResult", sender: query)
            })
            .disposed(by: disposeBag)
        viewModel.output.isSearchable
            .drive(buttonSearch.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    @IBSegueAction private func showResult(_ coder: NSCoder, sender: Any?) -> ResultViewController? {
        guard let query = sender as? KanjiQuery else {
            return nil
        }
        return ResultViewController.init(coder: coder, query: query)
    }

}
