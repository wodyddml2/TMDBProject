import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD
import Kingfisher

enum HeaderTitle: String, CaseIterable {
    case OverView
    case Cast
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTabelView: UITableView!
    
    @IBOutlet weak var backPosterImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    let hub = JGProgressHUD()
    
    var detailList: MovieInfo?
    var castList: [CastInfo] = []
    
    var beforePageName: String?
    
    var openCloseImage = "chevron.down"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "출연/제작"
        print(detailList!)
        
        detailTabelView.delegate = self
        detailTabelView.dataSource = self
        
        detailTabelView.register(UINib(nibName: OverViewDetailTableViewCell.resuableIdentifier, bundle: nil), forCellReuseIdentifier: OverViewDetailTableViewCell.resuableIdentifier)
        
        detailTabelView.register(UINib(nibName: CastDetailTableViewCell.resuableIdentifier, bundle: nil), forCellReuseIdentifier: CastDetailTableViewCell.resuableIdentifier)
        //
        
        backPosterImage.kf.setImage(with: detailList?.movieBackPoster)
        backPosterImage.contentMode = .scaleAspectFill
        
        posterImage.kf.setImage(with: detailList?.moviePoster)
        
        movieTitleLabel.text = detailList?.movieTitle
        movieTitleLabel.movieLabel(.white, .boldSystemFont(ofSize: 20))
        requestCast()
    }
    
    func requestCast() {
        hub.show(in: view)
        let endPoint = beforePageName == MovieViewController.resuableIdentifier ? EndPoint.movie.tmdbURL : EndPoint.tv.tmdbURL
        
        RequestTMDBAPIManager.shared.requestCast(endPoint,detailList!.movieID) { castList in
            self.castList.append(contentsOf: castList)
            
            DispatchQueue.main.async {
                self.detailTabelView.reloadData()
            }
            self.hub.dismiss(animated: true)
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HeaderTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return castList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let overviewCell = tableView.dequeueReusableCell(withIdentifier: OverViewDetailTableViewCell.resuableIdentifier, for: indexPath) as? OverViewDetailTableViewCell else {
                return UITableViewCell()
            }
            overviewCell.overviewLabel.text = detailList?.movieOverView
            
            overviewCell.overviewStyle()
            
            overviewCell.openCloseButton.setImage(UIImage(systemName: openCloseImage), for: .normal)
            return overviewCell
        } else {
            guard let castCell = tableView.dequeueReusableCell(withIdentifier: CastDetailTableViewCell.resuableIdentifier, for: indexPath) as? CastDetailTableViewCell else {
                return UITableViewCell()
            }
            
            castCell.profileImage.kf.setImage(with: castList[indexPath.row].profile)
            castCell.realNameLabel.text = castList[indexPath.row].realName
            castCell.movieNameLabel.text = "\(castList[indexPath.row].movieName)/ "
            castCell.departmentLabel.text = castList[indexPath.row].department
            
            castCell.castCellStyle()
            
            return castCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if openCloseImage == "chevron.down" {
                openCloseImage = "chevron.up"
            } else {
                openCloseImage = "chevron.down"
            }
            tableView.reloadData()
        } else {
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return HeaderTitle.OverView.rawValue
        } else {
            return HeaderTitle.Cast.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            let changeOverview = openCloseImage == "chevron.down" ? tableView.frame.size.height / 6 : UITableView.automaticDimension
            return changeOverview
            // .automaticDimension: 테이블 뷰에서 사용하는 타입 프로퍼티로 반환된 값에 알맞는 높이를 제공한다.
        } else {
            return tableView.frame.size.height / 6
        }
        
    }
}

