import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    @IBOutlet weak var movieBackgroundView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateValueLabel: UILabel!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var sectionLine: UIView!
    
    func cellStyle() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        
        releaseLabel.font = .systemFont(ofSize: 14)
        releaseLabel.textColor = .darkGray
        
        genreLabel.font = .boldSystemFont(ofSize: 17)
        
        movieBackgroundView.layer.masksToBounds = true
        movieBackgroundView.layer.cornerRadius = 6
        movieBackgroundView.backgroundColor = .clear
        
        movieImage.contentMode = .scaleAspectFill
        
        rateLabel.text = "평점"
        rateLabel.movieLabel(15, .white)
        rateLabel.textAlignment = .center
        rateLabel.backgroundColor = UIColor(named: "rateColor")
        
        rateValueLabel.movieLabel(15, .black)
        rateValueLabel.textAlignment = .center
        rateValueLabel.backgroundColor = .white
        
        movieTitleLabel.movieLabel(19, .black)
        overviewLabel.movieLabel(16, .darkGray)
        
        detailLabel.text = "자세히 보기"
        detailLabel.font = .systemFont(ofSize: 16)
        
        detailButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        detailButton.tintColor = .darkGray
        
        sectionLine.backgroundColor = .black
        
    }
}
