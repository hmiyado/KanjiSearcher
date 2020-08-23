//

import Foundation
import RxCocoa
import RxSwift
import RxTest

extension TestScheduler {
    func createObserver<T>(with driver: Driver<T>, disposedBy disposeBag: DisposeBag) -> TestableObserver<T> {
        let observer = self.createObserver(T.self)
        driver.drive(observer).disposed(by: disposeBag)
        return observer
    }
}
