//
//  BikeListViewController.swift
//  RockYou
//
//  Created by PC on 2022/10/12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainViewController: UIViewController{
        
    let viewModel = LabelViewModel()
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()

    
    @IBOutlet weak var bicycleRegBtn: UIButton!
    @IBOutlet weak var bicycleRemoveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bicycleRegBtn.layer.cornerRadius = 20
        bicycleRemoveBtn.layer.cornerRadius = 20
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.syncCollectioview()
    }
    
    private func serverRead(){
        // get user document
        db.collection("bicycle").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    guard let documentUid = document.get("uid") as? String else { return }
                    //로그인한 유저의 uid와 저장된 uid가 같은 바이크 정보 불러오기
                    if(documentUid == userid){
                        //print("\(document.documentID) => \(document.data())")
                        let bicycleNickname = document.get("bicycleNickname") as! String
                        let idnum = document.documentID
                        let state = document.get("state") as! Int
                        let viewColor = self.stateCheckViewChange(state: state)
                        let labelColor = self.stateCheckLabelColorChange(state: state)
                        let label = self.stateCheckLabelChange(state: state)
                        let labelInfo = LabelInfo(nickname: bicycleNickname, idnum: idnum, state: label, viewColor: viewColor, labelColor: labelColor)
                        self.viewModel.labelInfoList.append(labelInfo) //viewModel 전역변수
                        self.collectionView.reloadData() // 데이터 추가 후 컬렉션뷰 한번 리로딩 해줘서 바로 화면에 나타나도록
                    }
                }
            }
        }
    }
    
    private func removeServerData(collection:String, document:String){
        
        db.collection(collection).document(document).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    
    func stateCheckViewChange(state : Int) -> UIColor{
        if state == 0{ //잠금중
            return UIColor.yellow
        } else if state == 1{ //주행중
            return UIColor.white
        } else {
            return UIColor.red
        }
    }
    
    func stateCheckLabelColorChange(state : Int) -> UIColor{
        if state == 0{ //잠금중
            return UIColor.black
        } else if state == 1{ //주행중
            return UIColor.black
        } else {
            return UIColor.red
        }
    }
    
    func stateCheckLabelChange(state : Int) -> String{
        if state == 0{ //잠금중
            return "잠금중"
        } else if state == 1{ //주행중
            return "주행중"
        } else {
            return "도난!!"
        }
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        // Do you your api calls in here, and then asynchronously remember to stop the
        // refreshing when you've got a result (either positive or negative)
        DispatchQueue.main.asyncAfter(deadline:.now()+1.5) {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.syncCollectioview()
            
        }
    }
    
    // 서버의 값으로 컬력센뷰 동기화
    func syncCollectioview(){
        // 컬렉션뷰의 데이터 삭제
        let removeCount = self.viewModel.countOfList
        for _ in 0..<removeCount{
            self.viewModel.labelInfoList.removeFirst()
        }
        self.serverRead()
    }
    
    // 등록 버튼 클릭
    @IBAction func bicycleRegisterBtnDidTap(_ sender: Any) {
        guard let regVC = self.storyboard?.instantiateViewController(withIdentifier: "BicycleRegisterViewController") as? BicycleRegisterViewController else { return }
        regVC.modalPresentationStyle = .fullScreen
        self.present(regVC, animated: true)
    }
    
    // 삭제 버튼 클릭
    @IBAction func bicycleRemoveBtnDidTap(_ sender: Any) {
        let title = "자전거 삭제"
        let message = "삭제하고 싶은 자전거의 별명을 입력하세요"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var bluetooth: String = ""
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) { (_) in
            // alert 텍스트필드 창 여려개 가능 -> 0번째 창에 텍스트 가져옴
            if let txt = alert.textFields?[0]{
                if txt.text?.isEmpty != true{
                    
                    self.db.collection("bicycle").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                guard let txtname = document.get("bicycleNickname") as? String else { return }
                                if(txtname == txt.text!){
                                    let idnum = document.documentID
                                    bluetooth = idnum
                                    self.removeServerData(collection: "bicycle", document: bluetooth)
                                    
                                    self.syncCollectioview()
                                }
                            }
                        }
                    }
                    
                } else {
                    print("입력된 값이 없음")
                }
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        alert.addTextField(){ (tx) in
            tx.placeholder = "자전거 별명을 입력하세요"
        }
        
        
        self.present(alert, animated: true)
    }
}


class Cell: UICollectionViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var idnumLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateColorView: UIView!
    
    func update(info: LabelInfo) {
        nicknameLabel.text = info.nickname
        idnumLabel.text = info.idnum
        stateLabel.text = info.state
        stateColorView.backgroundColor = info.viewColor
        stateLabel.textColor = info.labelColor
        
        nicknameLabel.sizeToFit()
        
        stateColorView.layer.cornerRadius = 10
        stateColorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}

// MapView에 넘길 변수
var bicycleName : String = ""

//컬렉션뷰 함수 모아둠
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        let labelInfo = viewModel.labelInfo(at: indexPath.item)
        cell.update(info: labelInfo)
                
        return cell
    }
    
    //컬렉션 뷰 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        //let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 1
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        //let itemsPerColumn: CGFloat = 2
        //let heightPadding = sectionInsets.top * (itemsPerColumn + 10)
        let cellWidth = ((width - widthPadding) / itemsPerRow)-40
        //let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: 100)
    }
    
    
    //셀 클릭 이밴트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let labelInfo = viewModel.labelInfo(at: indexPath.item)
        bicycleName = labelInfo.nickname
        
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        performSegue(withIdentifier: "showSegue", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 데이터를 전달할 뷰 컨트롤러가 존재하는지 확인
        guard let mapViewController = segue.destination as? MapViewController else { return }
        // 대상 뷰 컨트롤러 존재하면 데이터 전달
        mapViewController.bicycleNicknameOfCell = bicycleName
        mapViewController.modalPresentationStyle = .fullScreen
    }
    
}
