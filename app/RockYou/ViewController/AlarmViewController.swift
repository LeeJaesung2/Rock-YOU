//
//  AlarmViewController.swift
//  RockYou
//
//  Created by PC on 2022/11/16.
//

import UIKit
import AVFoundation
import FirebaseFirestore

let alarmModel = AlarmTableModel()
var state: Int = 0

class AlarmViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        resetBtn.layer.cornerRadius = 18
        
        tableview.delegate = self
        tableview.dataSource = self
                
        update()
    }
    
    public func update(){
        if timer != nil && timer!.isValid{
            timer!.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stateCheck), userInfo: nil, repeats: true)
    }
    
    var arr : [String] = []
    
    let db = Firestore.firestore()

    @objc func stateCheck() {
        db.collection("bicycle").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    guard let documentUid = document.get("uid") as? String else { return }
                    
                    //로그인한 유저의 uid와 클릭한 셀의 바이크별명에 대한 데이터 불러오기
                    if(documentUid == userid){
                        let documentId = document.documentID
                        let bicycleNickname = document.get("bicycleNickname") as! String
                        state = document.get("state") as! Int

                        let index = alarmModel.alarmDatas.firstIndex(of: "자전거 : \(bicycleNickname)가 도난되었습니다.")
                        
                        // 도난 상태 & 등록되지 않은 데이터면 배열에 데이터 추가
                        if(state == 2 && index == nil){
                            UIDevice.vibrate() // 진동 원하는 곳에 메소드 이거 추가하면 됨
                            self.arr.append(documentId)
                            alarmModel.alarmDatas.append("자전거 : \(bicycleNickname)가 도난되었습니다.")
                        }
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func resetBtnDidTap(_ sender: Any) {
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let document = arr[indexPath.row]
            self.arr.remove(at: indexPath.row)
            alarmModel.alarmDatas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            db.collection("bicycle").document(document).updateData(["state":0])
        } else if editingStyle == .insert{}
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmModel.countOfList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = alarmModel.alarmInfo(at: indexPath.row)
        return cell
    }
    
}

extension UIDevice {

    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
