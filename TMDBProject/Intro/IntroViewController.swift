import UIKit

class IntroViewController: UIPageViewController {

    var pageViewControllerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "introColor")
        
        createPageViewController()
        configurePageViewController()
    }
    
    func createPageViewController() {
        let sb = UIStoryboard(name: "Intro", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: FirstViewController.reusableIdentifier)
        let vc2 = sb.instantiateViewController(withIdentifier: SecondViewController.reusableIdentifier)
        pageViewControllerList = [vc1, vc2]
    }
    
    func configurePageViewController() {
        delegate = self
        dataSource = self
        
        guard let first = pageViewControllerList.first else {return}
        setViewControllers([first], direction: .forward, animated: true)
    }

}

extension IntroViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // firstIndex는 배열의 첫번째 인덱스부터 조회를 해서 일치하는 첫번째 값
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else {return nil}
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else {return nil}
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else {return 0}
        return index
    }
}
