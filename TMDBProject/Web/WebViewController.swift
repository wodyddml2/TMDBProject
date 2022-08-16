import UIKit
import WebKit
import Reusable


class WebViewController: UIViewController {

    @IBOutlet weak var movieVideoWeb: WKWebView!
    
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    
    
    var movieID: Int?
    var beforePageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestWeb()
        
        stopButton.webBarButtonStyle("multiply")
        goBackButton.webBarButtonStyle("chevron.backward")
        reloadButton.webBarButtonStyle("goforward")
        goForwardButton.webBarButtonStyle("chevron.forward")
    }
    
    private func requestWeb() {
        let endPoint = beforePageName == MovieViewController.reusableIdentifier ? EndPoint.movie.tmdbURL : EndPoint.tv.tmdbURL
        
        RequestTMDBAPIManager.shared.requestWeb(endPoint,movieID!) { request in
            self.movieVideoWeb.load(request)
        }
    }
    
    @IBAction func stopButtonClicked(_ sender: UIBarButtonItem) {
        movieVideoWeb.stopLoading()
    }
    @IBAction func goBackButtonClicked(_ sender: UIBarButtonItem) {
        if movieVideoWeb.canGoBack {
            movieVideoWeb.goBack()
        }
        
    }
    @IBAction func reloadButtonClicked(_ sender: UIBarButtonItem) {
        movieVideoWeb.reload()
    }
    @IBAction func goFowardButtonClicked(_ sender: UIBarButtonItem) {
        if movieVideoWeb.canGoForward {
            movieVideoWeb.goForward()
        }
    }
    
}
