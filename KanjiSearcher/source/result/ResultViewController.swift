//

import UIKit
import RxSwift

class ResultViewController: UIViewController {
    private let viewModel: ResultViewModelType = ResultViewModel.init(kanjiRepository: KanjiRepository())
    var query: KanjiQuery = KanjiQuery.init()
    private let disposableBag = DisposeBag()
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
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
                guard let self = self else {
                    return
                }
                switch searchStatus {
                case .loading:
                    self.activityIndicator?.hidesWhenStopped = true
                    self.activityIndicator?.isHidden = false
                    self.errorView?.removeFromSuperview()
                    self.activityIndicator?.startAnimating()
                case .success(payload: _):
                    self.activityIndicator?.isHidden = true
                case .error(error: _):
                    self.activityIndicator?.isHidden = true
                    if let errorView = self.errorView, let containerView = self.containerView {
                        containerView.addSubview(errorView)
                        errorView.translatesAutoresizingMaskIntoConstraints = false
                        errorView.centerXAnchor.constraint(equalToSystemSpacingAfter: containerView.centerXAnchor, multiplier: 1.0).isActive = true
                        errorView.centerYAnchor.constraint(equalToSystemSpacingBelow: containerView.centerYAnchor, multiplier: 1.0).isActive = true
                    }
                }
            })
            .disposed(by: disposableBag)
        
        viewModel.input.onQuery.accept(query)
    }
}
