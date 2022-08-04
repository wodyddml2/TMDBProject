import UIKit

class OverViewDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var overviewLabel: UILabel!
    
    func overviewStyle() {
        overviewLabel.movieLabel(.black, .systemFont(ofSize: 15))
        overviewLabel.numberOfLines = 0
    }
}
