
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // 하단바 아울렛
    @IBOutlet weak var underbarView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    // 뒤로가기 아울렛
    @IBOutlet weak var backButton: UIButton!
    
    
    // coordinate : 위도와 경도
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 하단 바 레이아웃
        underbarView.layer.cornerRadius = 40
        underbarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        lockButton.layer.cornerRadius = 25
        resetButton.layer.cornerRadius = 25
        
        backButton.layer.cornerRadius = 18
        
        self.mapView.mapType = MKMapType.standard
        configureLocationServices()
    }
    
    private func configureLocationServices(){
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus() // 위치 권한값을 가져옴
        
        if status == .notDetermined{
            //만약 gps 권한이 설정 되어 있지 않다면
            locationManager.requestAlwaysAuthorization() // 권한 설정 요청해라
        }else if status == .authorizedAlways || status == .authorizedWhenInUse{
            // beginLocationUpdates(locationManager: locationManager)
            setMapView(latitude: 37.6658609, longitude: 127.0317674 )
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true // 사용자 위치를 파란색 점으로 나타내는 것
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도를 최고로 해서
        locationManager.startUpdatingLocation() // location을 update해라
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let zoomRegion = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    private func setMapView(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        print("이거 실행 됐지??")
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    @IBAction func lockButtonDidTap(_ sender: Any) {
        print("잠금")
    }
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        print("리셋")
        
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("Did get latest location")
        
        // guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            //zoomToLatestLocation(with: latestLocation.coordinate)
        }
        //currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed") //만약 허용 했다가 나중에 권한을 금지 시키면 나오는 메세지
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            //beginLocationUpdates(locationManager: manager)
        }
    }
}
