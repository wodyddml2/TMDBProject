import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD
import Kingfisher

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
        
        navigationItem.backButtonTitle = " "
        
        navigationController?.navigationBar.tintColor = .black
        
        
        requestTMDB()
        
    }
    
    @objc func leftBar() {
        
    }
    @objc func rightBar() {
        
    }
    
    func requestTMDB() {
        hub.show(in: view)

        RequestTMDBAPIManager.shared.requestMovie(changePage) { totalPage, movieList in
            self.totalPage = totalPage
            self.movieList.append(contentsOf: movieList)
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
            self.hub.dismiss(animated: true)
        }
        
        
        RequestTMDBAPIManager.shared.requestGenre { genreList in
            self.genreList = genreList
            self.movieCollectionView.reloadData()
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
        
        cell.movieImage.kf.setImage(with: movieList[indexPath.row].moviePoster)
        cell.movieTitleLabel.text = movieList[indexPath.row].movieTitle
        cell.overviewLabel.text = movieList[indexPath.row].movieOverView
        cell.rateValueLabel.text = String(format: "%.1f", movieList[indexPath.row].movieRate)
        cell.releaseLabel.text = movieList[indexPath.row].movieRelease
        
        for (key, value) in genreList {
            if movieList[indexPath.row].movieGenre == key {
                cell.genreLabel.text = "#\(value)"
            }
        }
        
        cell.videoButton.addTarget(self, action: #selector(videoButtonClicked), for: .touchUpInside)
        
        cell.cellStyle()
        
        return cell
    }
    
    @objc func videoButtonClicked(_ sender: UIButton) {
        let webSB = UIStoryboard(name: "Web", bundle: nil)
        guard let webVC = webSB.instantiateViewController(withIdentifier: WebViewController.resuableIdentifier) as? WebViewController else { return }
        
        webVC.movieID = movieList[sender.tag].movieID
        
       navigationController?.pushViewController(webVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 10
        
        return CGSize(width: width / 1.1, height: width * 1.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailSB = UIStoryboard(name: "Detail", bundle: nil)
        guard let detailVC = detailSB.instantiateViewController(withIdentifier: DetailViewController.resuableIdentifier) as? DetailViewController else { return }
        
        detailVC.detailList = movieList[indexPath.item]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
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
