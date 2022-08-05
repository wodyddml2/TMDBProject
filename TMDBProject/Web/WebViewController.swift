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
        let webURL = "\(EndPoint.tmdbURL)/\(movieID!))/videos?api_key=\(APIKey.TMDB)"
        
        AF.request(webURL, method: .get).validate(statusCode: 200...400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                let urlValue = json["results"][0]["key"].stringValue

                guard let url = URL(string: "https://www.youtube.com/watch?v=\(urlValue)" ) else { return }
                
                let request = URLRequest(url: url)

                self.movieVideoWeb.load(request)
                
            case .failure(let error):

                print(error)
            }
            
        }
    }
}
