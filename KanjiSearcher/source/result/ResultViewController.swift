//

import RxSwift
import SnapKit
import UIKit

class ResultViewController: UIViewController {
    private let viewModel: ResultViewModelType
    private let disposableBag = DisposeBag()
    private var dataSource: ResultDataSource = ResultDataSource()
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var emptyView: UIStackView!
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
        let errorView = ResultErrorView()

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
                errorView.removeFromSuperview()
                self.emptyView?.removeFromSuperview()
                self.activityIndicator.center(in: self.containerView)
                self.activityIndicator?.startAnimating()
                self.tableView?.isHidden = true
            })
            .disposed(by: disposableBag)
        viewModel
            .output
            .errorSearching
            .drive(onNext: {[weak self] error in
                guard let self = self else {
                    return
                }
                self.activityIndicator?.removeFromSuperview()
                if let containerView = self.containerView {
                    containerView.addSubview(errorView)
                    errorView.snp.makeConstraints { (make) -> Void in
                        make.center.equalTo(containerView.safeAreaLayoutGuide)
                        make.width.equalTo(containerView.safeAreaLayoutGuide)
                        make.height.equalTo(containerView.safeAreaLayoutGuide)
                    }
                    errorView.showError(error)
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
                self.activityIndicator?.removeFromSuperview()
                self.tableView?.isHidden = false
                self.dataSource.results = kanjiResults
                self.tableView.reloadData()
            })
            .disposed(by: disposableBag)
        viewModel
            .output
            .emptySearching
            .drive(onNext: {[weak self] _ in
                guard let self = self else {
                    return
                }
                self.activityIndicator?.removeFromSuperview()
                self.emptyView.center(in: self.containerView)
            })
            .disposed(by: disposableBag)
        viewModel
            .output
            .showDetail
            .drive(onNext: { [weak self] kanjiInfo in
                guard let self = self else {
                    return
                }
                self.performSegue(withIdentifier: "showDetail", sender: kanjiInfo)
            })
            .disposed(by: disposableBag)

        viewModel.input.onQuery.accept(viewModel.input.onQuery.value)
    }

    @IBSegueAction func showDetail(_ coder: NSCoder, sender: Any?) -> DetailViewController? {
        guard let kanjiInfo = sender as? KanjiInfo else {
            return nil
        }
        return DetailViewController.init(coder: coder, kanjiInfo: kanjiInfo)
    }
}

extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
