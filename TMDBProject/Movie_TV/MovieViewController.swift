import UIKit
//import Reusable

import JGProgressHUD

import Kingfisher

enum DateCycle: String {
    case day
    case week
}

enum JsonItem: String {
    case title
    case release_date
    case name
    case first_air_date
}

class MovieViewController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    @IBOutlet weak var movieDayButton: UIButton!
    @IBOutlet weak var movieWeekButton: UIButton!
    
    private let hub = JGProgressHUD()
    
    private var dayMovieList: [MovieInfo] = []
    private var weekMovieList: [MovieInfo] = []
    
    private var genreList: [Int: String] = [:]
    
    private var dateCycle = DateCycle.day.rawValue
    private var dayChangePage = 1
    private var weekChangePage = 1
    private var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.prefetchDataSource = self
        
        movieCollectionView.register(UINib(nibName: MovieCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.reusableIdentifier)
        movieDayButton.dayWeekButtonClickedStyle("Day")
        movieWeekButton.dayWeekButtonStyle("Week")
        requestTMDB(DateCycle.day.rawValue)
        requestTMDB(DateCycle.week.rawValue)
        
    }
    
   
    
    private func requestTMDB(_ date: String) {
        hub.show(in: view)
        
        if date == DateCycle.day.rawValue {
            let url = "\(EndPoint.movie.tmdbTrendingURL)\(date)?api_key=\(APIKey.TMDB)&page=\(dayChangePage)"
            RequestTMDBAPIManager.shared.requestTMDB(url, JsonItem.title.rawValue, JsonItem.release_date.rawValue) { totalPage, movieList in
                self.totalPage = totalPage
              
                self.dayMovieList.append(contentsOf: movieList)
                
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
                self.hub.dismiss(animated: true)
            }
        } else {
            let url = "\(EndPoint.movie.tmdbTrendingURL)\(date)?api_key=\(APIKey.TMDB)&page=\(weekChangePage)"
            RequestTMDBAPIManager.shared.requestTMDB(url, JsonItem.title.rawValue, JsonItem.release_date.rawValue) { totalPage, movieList in
                self.totalPage = totalPage
              
                self.weekMovieList.append(contentsOf: movieList)
                
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
                self.hub.dismiss(animated: true)
            }
        }
        
        let genreURL = "\(EndPoint.movie.tmdbGenreURL)api_key=\(APIKey.TMDB)"
        
        RequestTMDBAPIManager.shared.requestGenre(genreURL) { genreList in
            
            self.genreList = genreList
            self.movieCollectionView.reloadData()
        }
    }
    @IBAction func movieDayButtonClicked(_ sender: UIButton) {
        if movieDayButton.backgroundColor == .black {
            dateCycle = DateCycle.day.rawValue
            self.movieCollectionView.reloadData()
            movieDayButton.dayWeekButtonClickedStyle("Day")
            movieWeekButton.dayWeekButtonStyle("Week")
            movieCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

        }
        
    }
    @IBAction func movieWeekButtonClicked(_ sender: UIButton) {
        if movieWeekButton.backgroundColor == .black {
            dateCycle = DateCycle.week.rawValue
            self.movieCollectionView.reloadData()
            movieWeekButton.dayWeekButtonClickedStyle("Week")
            movieDayButton.dayWeekButtonStyle("Day")
            movieCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    
}

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dateCycle == DateCycle.day.rawValue {
            return dayMovieList.count
        } else {
            return weekMovieList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reusableIdentifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        if dateCycle == DateCycle.day.rawValue {
            cell.movieImage.kf.setImage(with: dayMovieList[indexPath.row].moviePoster)
            cell.movieTitleLabel.text = dayMovieList[indexPath.row].movieTitle
            cell.overviewLabel.text = dayMovieList[indexPath.row].movieOverView
            cell.rateValueLabel.text = String(format: "%.1f", dayMovieList[indexPath.row].movieRate)
            cell.releaseLabel.text = dayMovieList[indexPath.row].movieRelease
            
            for (key, value) in genreList {
                if dayMovieList[indexPath.row].movieGenre == key {
                    cell.genreLabel.text = "#\(value)"
                }
            }
        } else {
            cell.movieImage.kf.setImage(with: weekMovieList[indexPath.row].moviePoster)
            cell.movieTitleLabel.text = weekMovieList[indexPath.row].movieTitle
            cell.overviewLabel.text = weekMovieList[indexPath.row].movieOverView
            cell.rateValueLabel.text = String(format: "%.1f", weekMovieList[indexPath.row].movieRate)
            cell.releaseLabel.text = weekMovieList[indexPath.row].movieRelease
            
            for (key, value) in genreList {
                if weekMovieList[indexPath.row].movieGenre == key {
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
        guard let webVC = webSB.instantiateViewController(withIdentifier: WebViewController.reusableIdentifier) as? WebViewController else { return }
        if dateCycle == DateCycle.day.rawValue {
            webVC.movieID = dayMovieList[sender.tag].movieID
        } else {
            webVC.movieID = weekMovieList[sender.tag].movieID
        }
            webVC.beforePageName = MovieViewController.reusableIdentifier
        
       navigationController?.pushViewController(webVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 10
        
        return CGSize(width: width / 1.1, height: width * 1.1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailSB = UIStoryboard(name: "Detail", bundle: nil)
        guard let detailVC = detailSB.instantiateViewController(withIdentifier: DetailViewController.reusableIdentifier) as? DetailViewController else { return }
        if dateCycle == DateCycle.day.rawValue {
            detailVC.detailList = dayMovieList[indexPath.item]
        } else {
            detailVC.detailList = weekMovieList[indexPath.item]
        }
        
        detailVC.beforePageName = MovieViewController.reusableIdentifier
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MovieViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if dateCycle == DateCycle.day.rawValue && dayMovieList.count - 1 == indexPath.item && dayMovieList.count < totalPage {
                dayChangePage += 1
                requestTMDB("day")
            } else if dateCycle == DateCycle.week.rawValue && weekMovieList.count - 1 == indexPath.item && weekMovieList.count < totalPage {
                weekChangePage += 1
                requestTMDB("week")
            }
        }
    }
    
}

