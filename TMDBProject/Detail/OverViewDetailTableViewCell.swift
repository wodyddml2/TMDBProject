import UIKit

class OverViewDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var openCloseButton: UIButton!
    
    func overviewStyle() {
        overviewLabel.movieLabel(.black, .systemFont(ofSize: 15))
        overviewLabel.numberOfLines = 0
        
        openCloseButton.setTitle("", for: .normal)
        
        openCloseButton.tintColor = .black
    }
  
   
//    chevron.up
    
}
