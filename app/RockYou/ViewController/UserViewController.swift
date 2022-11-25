//
//  UserViewController.swift
//  RockYou
//
//  Created by PC on 2022/11/16.
//

import UIKit
import FirebaseFirestore

class UserViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var listView: UITextView!

    var nickString = ""
    var idString = ""
    var passwordString = ""
    
    
    private lazy var nicknameLabel : UILabel = {
        let label = UILabel()
        label.text = self.nickString
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var idLabel : UILabel = {
        let label = UILabel()
        label.text = self.idString
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordLabel : UILabel = {
        let label = UILabel()
        label.text = self.passwordString
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var idSetLabel : UILabel = {
        let label = UILabel()
        label.text = "아이디 : "
        label.font = .boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passwordSetLabel : UILabel = {
        let label = UILabel()
        label.text = "비밀번호 : "
        label.font = .boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserData()
        addBicycleList()
        
    }
    
    private func viewInit(){
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        imageView.layer.cornerRadius = imageView.layer.bounds.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.fill")
        
        nicknameView.layer.cornerRadius = 15
        idView.layer.cornerRadius = 15
        passwordView.layer.cornerRadius = 15
        listView.layer.cornerRadius = 15
        addViewLabel()
    }
   
    private func addViewLabel(){
        
        nicknameView.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
            self.nicknameLabel.centerYAnchor.constraint(equalTo: self.nicknameView.centerYAnchor),
            self.nicknameLabel.leadingAnchor.constraint(equalTo: self.nicknameView.leadingAnchor, constant: 10),
            self.nicknameLabel.trailingAnchor.constraint(equalTo: self.nicknameView.trailingAnchor, constant: 15),
        ])
        
        idView.addSubview(idSetLabel)
        NSLayoutConstraint.activate([
            self.idSetLabel.centerYAnchor.constraint(equalTo: self.idView.centerYAnchor),
            self.idSetLabel.leadingAnchor.constraint(equalTo: self.idView.leadingAnchor, constant: 10),
        ])
        
        idView.addSubview(idLabel)
        NSLayoutConstraint.activate([
            self.idLabel.centerYAnchor.constraint(equalTo: self.idView.centerYAnchor),
            self.idLabel.leadingAnchor.constraint(equalTo: self.idSetLabel.trailingAnchor, constant: 7),
            self.idLabel.trailingAnchor.constraint(equalTo: self.idView.trailingAnchor, constant: 15),
        ])
        
        passwordView.addSubview(passwordSetLabel)
        NSLayoutConstraint.activate([
            self.passwordSetLabel.centerYAnchor.constraint(equalTo: self.passwordView.centerYAnchor),
            self.passwordSetLabel.leadingAnchor.constraint(equalTo: self.passwordView.leadingAnchor, constant: 10),
        ])
        
        passwordView.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            self.passwordLabel.centerYAnchor.constraint(equalTo: self.passwordView.centerYAnchor),
            self.passwordLabel.leadingAnchor.constraint(equalTo: self.passwordSetLabel.trailingAnchor, constant: 7),
            self.passwordLabel.trailingAnchor.constraint(equalTo: self.passwordView.trailingAnchor, constant: 15),
        ])
    }
    
    private func setUserData(){
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")

                    guard let uid = document.get("uid") as? String else { return }
                    if(uid == userid){
                        self.nickString = userid
                        self.idString = document.documentID
                        self.passwordString = document.get("password") as! String
                        
                        self.viewInit()
                    }
                }
            }
        }
    }
    
    var bicycleListString = ""
    
    private func addBicycleList(){
        db.collection("bicycle").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    guard let documentUid = document.get("uid") as? String else { return }
                    //로그인한 유저의 uid와 저장된 uid가 같은 바이크 정보 불러오기
                    if(documentUid == userid){
                        let bicycleNickname = document.get("bicycleNickname")! as! String
                        self.bicycleListString += bicycleNickname
                        self.bicycleListString += "\n"
                    }
                }
                self.listView.text = self.bicycleListString

            }
        }
    }
    
    
//
//    func updatePeople()
//    {
//        for peop in personArray{
//            thePeople.text = ""
//        }
//    }
}
