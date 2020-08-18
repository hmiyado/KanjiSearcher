//

import Foundation
import UIKit

extension UIView {
    func center(in containerView: UIView) {
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalToSystemSpacingAfter: containerView.centerXAnchor, multiplier: 1.0).isActive = true
        self.centerYAnchor.constraint(equalToSystemSpacingBelow: containerView.centerYAnchor, multiplier: 1.0).isActive = true
    }
}
