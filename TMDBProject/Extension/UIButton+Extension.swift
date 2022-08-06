import UIKit

extension UIButton {
    func dayWeekButtonStyle(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.tintColor = .lightGray
        self.backgroundColor = .black
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
    func dayWeekButtonClickedStyle(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.tintColor = .lightGray
        self.backgroundColor = .darkGray
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
}

extension UIBarButtonItem {

    func webBarButtonStyle(_ image: String) {
        self.title = ""
        self.image = UIImage(systemName: image)
        self.tintColor = .darkGray
        
        
    }
   
}
