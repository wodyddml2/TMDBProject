import UIKit
import MapKit
import CoreLocation
//import Reusable


class MapViewController: UIViewController {

    @IBOutlet weak var movieTheaterMapView: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    
    private let theaterList = TheaterList()
    
    var currentLocation: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(rightButtonClicked))
        navigationController?.navigationBar.tintColor = .darkGray
        
        locationManager.delegate = self
        
        currentLocationButton.setImage(UIImage(systemName: "location.circle"), for: .normal)
        currentLocationButton.setTitle("", for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.tintColor = .darkGray
    }
    
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func rightButtonClicked() {
            
        showNearbyTheaterAlert { _ in
            self.movieTheaterMapView.removeAnnotations(self.movieTheaterMapView.annotations)
            for list in self.theaterList.mapAnnotations {
                self.setRegionAnnotation(CLLocationCoordinate2D(latitude: list.latitude, longitude: list.longitude), list.location, 14000)
            }
        } completionHandler: { action in
            self.alertAction(action)
        }
        
    }

    private func setRegionAnnotation(_ center: CLLocationCoordinate2D,_ title: String,_ meter: Double) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: meter, longitudinalMeters: meter)
        
        movieTheaterMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        
        movieTheaterMapView.addAnnotation(annotation)
       
    }
    
    @IBAction func currentLocationButtonClicked(_ sender: UIButton) {
        setRegionAnnotation(currentLocation ?? CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270), "현재 위치", 1000)
    }
    
}

extension MapViewController {
    private func checkUserDeviceLocationServiceAuthorization() {
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
    
    private  func checkUserCurrentLocationAuthorization(_ authorization: CLAuthorizationStatus) {
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
    
    private func alertAction(_ action: UIAlertAction) {
        movieTheaterMapView.removeAnnotations(movieTheaterMapView.annotations)
        for list in theaterList.mapAnnotations {
            if action.title == list.type {
                setRegionAnnotation(CLLocationCoordinate2D(latitude: list.latitude, longitude: list.longitude), list.location, 9000)
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegionAnnotation(coordinate, "현재 위치", 1000)
            currentLocation = coordinate
        }
        
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail")
    }
    
    // iOS 14 이후
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
        print(#function)
    }
    // 이전
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
