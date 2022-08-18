import UIKit
import Reusable

extension UIViewController {
    enum Transition {
        case push
        case present
    }
    
    func transitionViewController<T: UIViewController>(stroyboard sb: String, viewController: T, transition: Transition, completion: (T) -> ()) {
        switch transition {
        case .push:
            guard let vc = UIStoryboard(name: sb, bundle: nil).instantiateViewController(withIdentifier: T.reusableIdentifier) as? T else { return }
            completion(vc)
            navigationController?.pushViewController(vc, animated: true)
        case .present:
            guard let vc = UIStoryboard(name: sb, bundle: nil).instantiateViewController(withIdentifier: T.reusableIdentifier) as? T else { return }
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
}

