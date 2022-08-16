import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var firstIntroImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "introColor")
        firstIntroImageView.image = UIImage(named: "tv")
    }

}
