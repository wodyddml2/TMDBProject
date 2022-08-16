import UIKit
import Reusable

import Tabman
import Pageboy


class ViewController: TabmanViewController {

    private var viewControllerArr: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let movieVC = sb.instantiateViewController(withIdentifier: MovieViewController.reusableIdentifier) as? MovieViewController else {return}
        guard let tvVC = sb.instantiateViewController(withIdentifier: TvViewController.reusableIdentifier) as? TvViewController else {return}
        
        viewControllerArr.append(contentsOf: [movieVC, tvVC])
        
        
        self.dataSource = self
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(leftBar))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightBar))
        
        navigationItem.backButtonTitle = " "
        
        navigationController?.navigationBar.tintColor = .black
        
        TMBbarStyle()
    }
    
    private func TMBbarStyle() {
        let bar = TMBar.ButtonBar()
        
        bar.layout.transitionStyle = .snap
        
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        bar.layout.contentMode = .fit
        
        bar.backgroundView.style = .blur(style: .light)
        
        bar.buttons.customize { button in
            button.selectedTintColor = .darkGray
        }
        
        bar.indicator.weight = .heavy
        bar.indicator.tintColor = .darkGray
        bar.indicator.overscrollBehavior = .compress
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    @objc private func leftBar() {
        let mapSB = UIStoryboard(name: "Map", bundle: nil)
        guard let mapVC = mapSB.instantiateViewController(withIdentifier: MapViewController.reusableIdentifier) as? MapViewController else { return }
        
        
        
        let mapNav = UINavigationController(rootViewController: mapVC)
        mapNav.modalPresentationStyle = .fullScreen
        present(mapNav, animated: true)

    }
    @objc func rightBar() {
        
    }

}
extension ViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        if index == 0 {
            item.title = "Movie"
        } else {
            item.title = "TV"
        }
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllerArr.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllerArr[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
