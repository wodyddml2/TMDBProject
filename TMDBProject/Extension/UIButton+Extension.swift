import UIKit

extension UIButton {
    
}

extension UIBarButtonItem {
    
    func webBarButtonStyle(_ image: String) {
        self.title = ""
        self.image = UIImage(systemName: image)
        self.tintColor = .darkGray
    }
   
}
