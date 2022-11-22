
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate{
    
    // 하단바 아울렛
    @IBOutlet weak var underbarView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    // 뒤로가기 아울렛
    @IBOutlet weak var backButton: UIButton!
    
    
    // 위치조정 controller
    private let locationManager = CLLocationManager()
    // mapMark
    private let mark = Marker(coordinate: nil)
    //mapView 아울렛
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 하단 바 레이아웃
        underbarView.layer.cornerRadius = 40
        underbarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        lockButton.layer.cornerRadius = 25
        resetButton.layer.cornerRadius = 25
        
        backButton.layer.cornerRadius = 18
        
        //앱 강제 종류 해도 맵에서 오류 안나게 세팅
        self.mapView.mapType = MKMapType.standard
        
        // 앱 위치 이동
        locationManager.delegate = self
        setMapView(latitude: 37.6658609, longitude: 127.0317674 )
        
    }
    
    private func setMapView(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        Marking(latitude: latitude, longitude: longitude)
    }
    
    private func Marking(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        self.mapView.removeAnnotation(mark)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mark = Marker(coordinate: coordinate)
        mapView.addAnnotation(mark)
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
