import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var secondIntroTitleLabel: UILabel!
    @IBOutlet weak var secondIntroSubtitleLabel: UILabel!
    
    @IBOutlet weak var secondIntroStartLabel: UILabel!
    
    @IBOutlet weak var secondIntroButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "introColor")
        secondIntroTitleLabel.text = "TMDB"
        secondIntroTitleLabel.font = UIFont(name: "twayair", size: 50)
        
        secondIntroSubtitleLabel.text = "최신 영화와 드라마의 정보를 이곳에서 확인하세요!!"
        secondIntroSubtitleLabel.font = UIFont(name: "twayair", size: 18)
        
        secondIntroStartLabel.text = "시작하기"
        secondIntroStartLabel.textColor = .darkGray
        secondIntroStartLabel.font = UIFont(name: "twayair", size: 35)
        
        secondIntroButton.setTitle("", for: .normal)

    }
    
    @IBAction func secondIntroButtonClicked(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "Intro")
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewController.reusableIdentifier) as? ViewController else {return}
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}
