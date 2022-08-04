import UIKit

class CastDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    func castCellStyle() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 12
        
        realNameLabel.movieLabel(.black, .boldSystemFont(ofSize: 18))
        
        movieNameLabel.movieLabel(.darkGray, .systemFont(ofSize: 15))
        departmentLabel.movieLabel(.darkGray, .systemFont(ofSize: 15))
    }
    
}
