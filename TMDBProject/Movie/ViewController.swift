import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    let hub = JGProgressHUD()
    
    var movieList: [MovieInfo] = []
    var genreList: [Int: String] = [:]
    var changePage = 1
    var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.prefetchDataSource = self
        
        movieCollectionView.register(UINib(nibName: MovieCollectionViewCell.resuableIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.resuableIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(leftBar))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightBar))
        
        navigationController?.navigationBar.tintColor = .black
        
        requestTMDB()
        
    }
    
    @objc func leftBar() {
        
    }
    @objc func rightBar() {
        
    }

    func requestTMDB() {
        hub.show(in: view)
        let url = "\(EndPoint.tmdbURL)api_key=\(APIKey.TMDB)&page=\(changePage)"
        let genreURL = "\(EndPoint.tmdbGenreURL)api_key=\(APIKey.TMDB)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for movie in json["results"].arrayValue {
                    self.totalPage = json["total_pages"].intValue
                    // 서버 통신 할 때 이미지의 모든 변환을 이 안에서 하면 서버 통신이 느려진다. / URL타입변환까진 얼마 차이 안난다함. Data타입만 cell에서 해주자!
                    let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie["poster_path"].stringValue)")
                    let imageData = try? Data(contentsOf: imageURL!)
                    
                    let movieData = MovieInfo(
                        movieTitle: movie["title"].stringValue,
                        moviePoster: imageData!,
                        movieOverView: movie["overview"].stringValue,
                        movieRate: Double(movie["vote_average"].stringValue) ?? 0,
                        movieRelease: movie["release_date"].stringValue,
                        movieGenre: movie["genre_ids"][0].intValue
                    )
                    
                    self.movieList.append(movieData)
                }
                self.hub.dismiss(animated: true)
                self.movieCollectionView.reloadData()
                
            case .failure(let error):
                self.hub.dismiss(animated: true)
                print(error)
            }
            
        }
        
        AF.request(genreURL, method: .get).validate(statusCode: 200...400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for movieGenre in json["genres"].arrayValue {
                     
                    self.genreList.updateValue(movieGenre["name"].stringValue, forKey: movieGenre["id"].intValue)
                }
                self.movieCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.resuableIdentifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.movieImage.image = UIImage(data: movieList[indexPath.row].moviePoster)
        cell.movieTitleLabel.text = movieList[indexPath.row].movieTitle
        cell.overviewLabel.text = movieList[indexPath.row].movieOverView
        cell.rateValueLabel.text = String(format: "%.1f", movieList[indexPath.row].movieRate)
        cell.releaseLabel.text = movieList[indexPath.row].movieRelease
   
        for (key, value) in genreList {
            if movieList[indexPath.row].movieGenre == key {
                cell.genreLabel.text = "#\(value)"
            }
        }
        
        cell.cellStyle()
        
        return cell
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 10
        
        return CGSize(width: width / 1.1, height: width * 1.1)
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieList.count - 1 == indexPath.item && movieList.count < totalPage {
                changePage += 1
                requestTMDB()
            }
        }
    }

}
