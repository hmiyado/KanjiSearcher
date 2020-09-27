//

import Foundation
import UIKit

extension UIView {
    func center(in containerView: UIView) {
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraintX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0)
        constraintX.isActive = true
        let constraintY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0)
        constraintY.isActive = true
    }
}
