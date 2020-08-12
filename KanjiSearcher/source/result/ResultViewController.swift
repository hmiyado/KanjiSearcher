//

import UIKit
import RxSwift

class ResultViewController: UIViewController {
    private let viewModel: ResultViewModelType = ResultViewModel.init(kanjiRepository: KanjiRepository())
    var query: KanjiQuery = KanjiQuery.init()
    private let disposableBag = DisposeBag()
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIStackView!
    
    init?(coder: NSCoder, query: KanjiQuery) {
        self.query = query
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel
            .output
            .searchStatus
            .drive(onNext: { [weak self] searchStatus in
                switch searchStatus {
                case .loading:
                    self?.activityIndicator?.hidesWhenStopped = true
                    self?.activityIndicator?.isHidden = false
//                    self?.errorView?.removeFromSuperview()
                    self?.activityIndicator?.startAnimating()
                case .success(payload: _):
                    self?.activityIndicator?.isHidden = true
                case .error(error: _):
//                    self?.activityIndicator?.isHidden = true
                    if let errorView = self?.errorView {
//                        self?.view?.addSubview(errorView)
                    }
                }
            })
            .disposed(by: disposableBag)
        
        viewModel.input.onQuery.accept(query)
    }
}
