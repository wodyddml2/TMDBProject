import UIKit
import WebKit

import Alamofire
import SwiftyJSON

class WebViewController: UIViewController {

    @IBOutlet weak var movieVideoWeb: WKWebView!
    
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    
    
    var movieID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestWeb()
        
        stopButton.webBarButtonStyle("multiply")
        goBackButton.webBarButtonStyle("chevron.backward")
        reloadButton.webBarButtonStyle("goforward")
        goForwardButton.webBarButtonStyle("chevron.forward")
    }
    
    func requestWeb() {
        RequestTMDBAPIManager.shared.requestWeb(movieID!) { request in
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
