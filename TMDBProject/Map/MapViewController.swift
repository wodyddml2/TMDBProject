import UIKit
import MapKit
import CoreLocation
import SwiftUI

class MapViewController: UIViewController {

    @IBOutlet weak var movieTheaterMapView: MKMapView!
    
    let theaterList = TheaterList()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(rightButtonClicked))
        navigationController?.navigationBar.tintColor = .darkGray
        
        locationManager.delegate = self
       
        
    }
    
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func rightButtonClicked() {
        showNearbyTheaterAlert()
    }

    func setRegionAnnotation(_ center: CLLocationCoordinate2D,_ title: String,_ meter: Double) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: meter, longitudinalMeters: meter)
        
        movieTheaterMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        
        movieTheaterMapView.addAnnotation(annotation)
       
    }
    

}

extension MapViewController {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorization: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorization = locationManager.authorizationStatus
        } else {
            authorization = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorization)
        } else {
            print("사용자의 위치 설정 필요")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorization: CLAuthorizationStatus) {
        switch authorization {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted,.denied:
            
            let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
            setRegionAnnotation(center, "청년취업사관학교 영등포 캠퍼스", 1000)
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default: print("default")
        }
    }
    func alertAction(_ action: UIAlertAction) {
        movieTheaterMapView.removeAnnotations(movieTheaterMapView.annotations)
        for list in theaterList.mapAnnotations {
            if action.title == list.type {
                setRegionAnnotation(CLLocationCoordinate2D(latitude: list.latitude, longitude: list.longitude), list.location, 9000)
            }
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
      }
    
    func showNearbyTheaterAlert() {
        let nearbyTheaterAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        let all = UIAlertAction(title: "전체보기", style: .default) { _ in
            for list in self.theaterList.mapAnnotations {
                    self.setRegionAnnotation(CLLocationCoordinate2D(latitude: list.latitude, longitude: list.longitude), list.location, 14000)
            }
            
        }
        let cgv = UIAlertAction(title: "CGV", style: .default) { action in
            self.alertAction(action)
            
        }
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { action in
            self.alertAction(action)
        }
        let megabox = UIAlertAction(title: "메가박스", style: .default) { action in
            self.alertAction(action)
        }
        
        [cancle, cgv, lotte, megabox, all].forEach {
            nearbyTheaterAlert.addAction($0)
        }
        
        present(nearbyTheaterAlert, animated: true)
       
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegionAnnotation(coordinate, "현재 위치", 1000)
        }
        
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail")
    }
    
    // iOS 14 이후
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    // 이전
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
