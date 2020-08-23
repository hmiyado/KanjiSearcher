//

import RxSwift
import UIKit

class ResultViewController: UIViewController {
    private let viewModel: ResultViewModelType
    private let disposableBag = DisposeBag()
    private var dataSource: ResultDataSource = ResultDataSource()
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorView: UIStackView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    init?(coder: NSCoder, query: KanjiQuery) {
        self.viewModel = ResultViewModel.init(kanjiRepository: KanjiRepository(), initialQuery: query)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self

        tableView.rx.itemSelected
            .bind(to: viewModel.input.onSelectItem)
            .disposed(by: disposableBag)

        viewModel
            .output
            .waitSearching
            .drive(onNext: {[weak self] _ in
                guard let self = self else {
                    return
                }
                self.errorView?.removeFromSuperview()
                self.activityIndicator.center(in: self.containerView)
                self.activityIndicator?.startAnimating()
                self.tableView?.isHidden = true
            })
            .disposed(by: disposableBag)
        viewModel
            .output
            .errorSearching
            .drive(onNext: {[weak self] _ in
                guard let self = self else {
                    return
                }
                self.activityIndicator?.removeFromSuperview()
                if let errorView = self.errorView, let containerView = self.containerView {
                    errorView.center(in: containerView)
                }
            })
            .disposed(by: disposableBag)
        viewModel
            .output
            .successSearching
            .drive(onNext: { [weak self] kanjiResults in
                guard let self = self else {
                    return
                }
                self.tableView?.isHidden = false
                self.dataSource.kanjiResults = kanjiResults
                self.tableView.reloadData()
                self.activityIndicator?.removeFromSuperview()
            })
            .disposed(by: disposableBag)
        viewModel
            .output
            .showDetail
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.performSegue(withIdentifier: "showDetail", sender: nil)
            })
            .disposed(by: disposableBag)

        viewModel.input.onQuery.accept(viewModel.input.onQuery.value)
    }
}

extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
