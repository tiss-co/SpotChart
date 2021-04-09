import Foundation
import UIKit

extension NSObject {
    @objc
    static var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension Int{
    func thousandSeprate() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal          // Set defaults to the formatter that are common for showing decimal numbers
        numberFormatter.usesGroupingSeparator = true    // Enabled separator
        numberFormatter.groupingSeparator = ","         // Set the separator to "," (e.g. 1000000 = 1,000,000)
        numberFormatter.groupingSize = 3
        let myFormatted = numberFormatter.string(for: self)
        return myFormatted
    }
}
