import UIKit

protocol ReusableProtocol {
    static var resuableIdentifier: String { get }
}

extension UIViewController: ReusableProtocol {
    static var resuableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    static var resuableIdentifier: String {
        return String(describing: self)
    }
}
