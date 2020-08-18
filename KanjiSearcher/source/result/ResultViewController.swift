//

import UIKit
import RxSwift

class ResultViewController: UIViewController {
    private let viewModel: ResultViewModelType = ResultViewModel.init(kanjiRepository: KanjiRepository())
    var query: KanjiQuery = KanjiQuery.init()
    private let disposableBag = DisposeBag()
    private var dataSource:ResultDataSource = ResultDataSource()
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorView: UIStackView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    init?(coder: NSCoder, query: KanjiQuery) {
        self.query = query
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.tableView.dataSource = dataSource
        
        viewModel
            .output
            .searchStatus
            .drive(onNext: { [weak self] searchStatus in
                guard let self = self else {
                    return
                }
                switch searchStatus {
                case .loading:
                    self.errorView?.removeFromSuperview()
                    self.activityIndicator.center(in: self.containerView)
                    self.activityIndicator?.startAnimating()
                    self.tableView?.isHidden = true
                case .success(payload: let payload):
                    self.tableView?.isHidden = false
                    self.dataSource.kanjiResults = payload
                    self.tableView.reloadData()
                    self.activityIndicator?.removeFromSuperview()
                case .error(error: _):
                    self.activityIndicator?.removeFromSuperview()
                    if let errorView = self.errorView, let containerView = self.containerView {
                        errorView.center(in: containerView)
                    }
                }
            })
            .disposed(by: disposableBag)
        
        viewModel.input.onQuery.accept(query)
    }
}
