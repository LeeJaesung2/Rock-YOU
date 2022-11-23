
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    // 하단바 아울렛
    @IBOutlet weak var underbarView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    // 뒤로가기 아울렛
    @IBOutlet weak var backButton: UIButton!
    // 위치조정 controller
    private let locationManager = CLLocationManager()
    // mapMark
    private let mark = Marker(coordinate: CLLocationCoordinate2D(latitude: 37.6658609, longitude: 127.0317674))
    //mapView 아울렛
    @IBOutlet weak var mapView: MKMapView!
    
    var timer : Timer?
    
    
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
        update()
    }
    
    public func update(){
        if timer != nil && timer!.isValid{
            timer!.invalidate()
        }
        
        timerNum = 10
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
       
           
        setMapView(latitude: 37.6628 , longitude: 127.0317674 )
            
      
    }
    
    @objc func getData(){
        //여기에 firebase map 값을 가져와서 아래 함수에 전달해 주시면 됩니다.
        moveLocation(latitude: 37.6658609, longitude: 127.0317674 )

    }
    
    private func moveLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
    
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        setAnnotation(latitudeValue: latitude, longtitudeValue: longitude)
    }
    
    private func setAnnotation(latitudeValue: CLLocationDegrees, longtitudeValue: CLLocationDegrees){
        mapView.removeAnnotation(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longtitudeValue)
        mapView.addAnnotation(annotation)
        print(latitude)
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
