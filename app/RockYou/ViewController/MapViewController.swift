
import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var bicycleNicknameOfCell : String = ""

    // 하단바 아울렛
    @IBOutlet weak var underbarView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    // 뒤로가기 아울렛
    @IBOutlet weak var backButton: UIButton!
    // 위치조정 controller
    private let locationManager = CLLocationManager()
    // mapMark
    private let marker = Marker(coordinate: CLLocationCoordinate2D(latitude: 37.6658609, longitude: 127.0317674))
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
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        
      //  setMapView(latitude: 37.6628 , longitude: 127.0317674 )
            
    }
    
    var latitude : CLLocationDegrees = 0.0
    var longitude : CLLocationDegrees = 0.0
    
    @objc func getData (){
        
        getGPSData()
    }
    
    //여기에 firebase map 값을 가져오는 곳
    private func getGPSData() {
        let db = Firestore.firestore()
        db.collection("bicycle").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    guard let documentUid = document.get("uid") as? String else { return }
                    guard let bicycleNickname = document.get("bicycleNickname") as? String else { return }

                    //로그인한 유저의 uid와 클릭한 셀의 바이크별명에 대한 데이터 불러오기
                    if(documentUid == userid && bicycleNickname == self.bicycleNicknameOfCell){
                        print("\(document.documentID) => \(document.data())")
                        let aaa = document.get("gps")
                        let point = aaa as! GeoPoint
                        self.latitude = point.latitude
                        self.longitude = point.longitude
                    }
                    
                    self.moveLocation(latitude: self.latitude, longitude: self.longitude )
                }
            }
        }
    }
    
    private func moveLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        setAnnotation(latitudeValue: latitude, longtitudeValue: longitude)
    }
    
    private func setAnnotation(latitudeValue: CLLocationDegrees, longtitudeValue: CLLocationDegrees){
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longtitudeValue)
        mapView.addAnnotation(annotation)
    }
    
    
    @IBAction func lockButtonDidTap(_ sender: Any) {
        print("잠금")
    }
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        print("리셋")
        
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        timer?.invalidate()
        dismiss(animated: true)
    }
}
