import UIKit

import Alamofire
import SwiftyJSON

import JGProgressHUD

import Kingfisher


class TvViewController: UIViewController {
    @IBOutlet weak var tvCollectionView: UICollectionView!
    
    @IBOutlet weak var tvDayButton: UIButton!
    @IBOutlet weak var tvWeekButton: UIButton!
    
    let hub = JGProgressHUD()
    
    var dayTVList: [MovieInfo] = []
    var weekTVList: [MovieInfo] = []
    
    var genreList: [Int: String] = [:]
    
    var dateCycle = DateCycle.day.rawValue
    var dayChangePage = 1
    var weekChangePage = 1
    var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvCollectionView.delegate = self
        tvCollectionView.dataSource = self
        tvCollectionView.prefetchDataSource = self
        
        tvCollectionView.register(UINib(nibName: MovieCollectionViewCell.resuableIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.resuableIdentifier)
        
        tvDayButton.dayWeekButtonClickedStyle("Day")
        tvWeekButton.dayWeekButtonStyle("Week")
        
        requestTMDB(DateCycle.day.rawValue)
        requestTMDB(DateCycle.week.rawValue)
        
    }
    
   
    
    func requestTMDB(_ date: String) {
        hub.show(in: view)
        
        if date == DateCycle.day.rawValue {
            let url = "\(TVEndPoint.tmdbTrendingURL)\(date)?api_key=\(APIKey.TMDB)&page=\(dayChangePage)"
            RequestTMDBAPIManager.shared.requestTMDB(url, JsonItem.name.rawValue, JsonItem.first_air_date.rawValue) { totalPage,movieList in
                self.totalPage = totalPage
              
                self.dayTVList.append(contentsOf: movieList)
                
                DispatchQueue.main.async {
                    self.tvCollectionView.reloadData()
                }
                self.hub.dismiss(animated: true)
            }
        } else {
            let url = "\(TVEndPoint.tmdbTrendingURL)\(date)?api_key=\(APIKey.TMDB)&page=\(weekChangePage)"
            RequestTMDBAPIManager.shared.requestTMDB(url, JsonItem.name.rawValue, JsonItem.first_air_date.rawValue) { totalPage, movieList in
                self.totalPage = totalPage
              
                self.weekTVList.append(contentsOf: movieList)
                
                DispatchQueue.main.async {
                    self.tvCollectionView.reloadData()
                }
                self.hub.dismiss(animated: true)
            }
        }
        
        let genreURL = "\(TVEndPoint.tmdbGenreURL)api_key=\(APIKey.TMDB)"
        
        RequestTMDBAPIManager.shared.requestGenre(genreURL) { genreList in
            self.genreList = genreList
            self.tvCollectionView.reloadData()
        }
    }
    @IBAction func tvDayButtonClicked(_ sender: UIButton) {
        if tvDayButton.backgroundColor == .black {
            dateCycle = DateCycle.day.rawValue
            self.tvCollectionView.reloadData()
            tvDayButton.dayWeekButtonClickedStyle("Day")
           tvWeekButton.dayWeekButtonStyle("Week")
            tvCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

        }
        
    }
    @IBAction func tvWeekButtonClicked(_ sender: UIButton) {
        if tvWeekButton.backgroundColor == .black {
            dateCycle = DateCycle.week.rawValue
            self.tvCollectionView.reloadData()
            tvWeekButton.dayWeekButtonClickedStyle("Week")
            tvDayButton.dayWeekButtonStyle("Day")
            tvCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    
}

extension TvViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dateCycle == DateCycle.day.rawValue {
            return dayTVList.count
        } else {
            return weekTVList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.resuableIdentifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        if dateCycle == DateCycle.day.rawValue {
            cell.movieImage.kf.setImage(with: dayTVList[indexPath.row].moviePoster)
            cell.movieTitleLabel.text = dayTVList[indexPath.row].movieTitle
            cell.overviewLabel.text = dayTVList[indexPath.row].movieOverView
            cell.rateValueLabel.text = String(format: "%.1f", dayTVList[indexPath.row].movieRate)
            cell.releaseLabel.text = dayTVList[indexPath.row].movieRelease
            
            for (key, value) in genreList {
                if dayTVList[indexPath.row].movieGenre == key {
                    cell.genreLabel.text = "#\(value)"
                }
            }
        } else {
            cell.movieImage.kf.setImage(with: weekTVList[indexPath.row].moviePoster)
            cell.movieTitleLabel.text = weekTVList[indexPath.row].movieTitle
            cell.overviewLabel.text = weekTVList[indexPath.row].movieOverView
            cell.rateValueLabel.text = String(format: "%.1f", weekTVList[indexPath.row].movieRate)
            cell.releaseLabel.text = weekTVList[indexPath.row].movieRelease
            
            for (key, value) in genreList {
                if weekTVList[indexPath.row].movieGenre == key {
                    cell.genreLabel.text = "#\(value)"
                }
            }
        }
        
        cell.videoButton.tag = indexPath.row
        cell.videoButton.addTarget(self, action: #selector(videoButtonClicked), for: .touchUpInside)
        
        cell.cellStyle()
        
        return cell
    }
    
    @objc func videoButtonClicked(_ sender: UIButton) {
        let webSB = UIStoryboard(name: "Web", bundle: nil)
        guard let webVC = webSB.instantiateViewController(withIdentifier: WebViewController.resuableIdentifier) as? WebViewController else { return }
        if dateCycle == DateCycle.day.rawValue {
            webVC.movieID = dayTVList[sender.tag].movieID
        } else {
            webVC.movieID = weekTVList[sender.tag].movieID
        }
            webVC.beforePageName = TvViewController.resuableIdentifier
        
       navigationController?.pushViewController(webVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 10
        
        return CGSize(width: width / 1.1, height: width * 1.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailSB = UIStoryboard(name: "Detail", bundle: nil)
        guard let detailVC = detailSB.instantiateViewController(withIdentifier: DetailViewController.resuableIdentifier) as? DetailViewController else { return }
        if dateCycle == DateCycle.day.rawValue {
            detailVC.detailList = dayTVList[indexPath.item]
        } else {
            detailVC.detailList = weekTVList[indexPath.item]
        }
        
        detailVC.beforePageName = TvViewController.resuableIdentifier
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension TvViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if dateCycle == DateCycle.day.rawValue && dayTVList.count - 1 == indexPath.item && dayTVList.count < totalPage {
                dayChangePage += 1
                requestTMDB("day")
            } else if dateCycle == DateCycle.week.rawValue && weekTVList.count - 1 == indexPath.item && weekTVList.count < totalPage {
                weekChangePage += 1
                requestTMDB("week")
            }
        }
    }
    
}
