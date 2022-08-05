import UIKit
import WebKit

import Alamofire
import SwiftyJSON

class WebViewController: UIViewController {

    @IBOutlet weak var movieVideoWeb: WKWebView!
    
    var movieID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestWeb()

    }
    
    func requestWeb() {
        RequestTMDBAPIManager.shared.requestWeb(movieID!) { request in
            self.movieVideoWeb.load(request)
        }
    }
}
