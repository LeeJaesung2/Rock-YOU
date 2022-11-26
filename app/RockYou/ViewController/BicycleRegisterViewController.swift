//
//  BicycleRegisterViewController.swift
//  RockYou
//
//  Created by PC on 2022/11/16.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BicycleRegisterViewController: UIViewController, WLITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // 프로그레스 바
    @IBOutlet weak var firstCircleView: UIView!
    @IBOutlet weak var firstToSecondConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondCircleView: UIView!
    @IBOutlet weak var secondToTirldConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressViewWidthConstraint2: NSLayoutConstraint!
    @IBOutlet weak var thirdCircleView: UIView!
    
    
    //레이블
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var txtNumberOfLocker: WLITextField!
    @IBOutlet weak var txtNicknameBicycle: WLITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var viewFlag = 1
    
    // 숫자 1 레이블
    lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "1"
        return label
    }()
    
    // 숫자 2 레이블
    lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "2"
        return label
    }()
    
    // 숫자 3 레이블
    lazy var threeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "3"
        return label
    }()
    
    // 블루투스 연결 레이블
    lazy var mainviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 48)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.tag = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        nextBtn.layer.cornerRadius = 20
        
        progressBarInit()
        
        stackView.isHidden = true
        txtNumberOfLocker.wliDelegate = self
        txtNicknameBicycle.wliDelegate = self
        
        
        // 초기화면 label
        self.view.addSubview(self.mainviewLabel)
        self.mainviewLabel.text = "블루투스를 연결해주세요"
        self.mainviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainviewLabel.topAnchor.constraint(equalTo: self.firstCircleView.bottomAnchor, constant: 40).isActive = true
        self.mainviewLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        self.mainviewLabel.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: 60).isActive = true
        
    }
    
    //1,2,3 progressBar 초기화
    func progressBarInit(){
        firstCircleView.layer.cornerRadius = firstCircleView.layer.bounds.width / 2
        firstCircleView.clipsToBounds = true
        firstCircleView.addSubview(oneLabel)
        oneLabel.translatesAutoresizingMaskIntoConstraints = false
        oneLabel.leadingAnchor.constraint(equalTo: firstCircleView.leadingAnchor, constant: 15).isActive = true
        oneLabel.topAnchor.constraint(equalTo: firstCircleView.topAnchor, constant: 12).isActive = true
        
        
        secondCircleView.layer.cornerRadius = secondCircleView.layer.bounds.width / 2
        secondCircleView.clipsToBounds = true
        secondCircleView.addSubview(twoLabel)
        twoLabel.translatesAutoresizingMaskIntoConstraints = false
        twoLabel.leadingAnchor.constraint(equalTo: secondCircleView.leadingAnchor, constant: 15).isActive = true
        twoLabel.topAnchor.constraint(equalTo: secondCircleView.topAnchor, constant: 12).isActive = true
        
        thirdCircleView.layer.cornerRadius = thirdCircleView.layer.bounds.width / 2
        thirdCircleView.clipsToBounds = true
        thirdCircleView.addSubview(threeLabel)
        threeLabel.translatesAutoresizingMaskIntoConstraints = false
        threeLabel.leadingAnchor.constraint(equalTo: thirdCircleView.leadingAnchor, constant: 15).isActive = true
        threeLabel.topAnchor.constraint(equalTo: thirdCircleView.topAnchor, constant: 12).isActive = true
        
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        if viewFlag == 1{
            UIView.animate(
                withDuration: 1,
                animations: {
                    self.firstToSecondConstraint.constant = 0
                    self.progressViewWidthConstraint.constant = 50
                    self.view.layoutIfNeeded()
                },
                completion: {_ in
                    self.secondCircleView.backgroundColor = .black
                }
            )
            
            DispatchQueue.main.async {
                // tag를 이용하여 view에서 컴포넌트 삭제
                if let viewWithTag = self.view.viewWithTag(1) {
                    viewWithTag.removeFromSuperview()
                }
            }
            stackView.isHidden = false
            nextButton.setTitle("등록하기", for:.normal)
            self.viewFlag = 2
        } else if viewFlag == 2{
            if self.txtNumberOfLocker.text?.count == 0 {
                ShowAlert(alertmsg: "자물쇠 번호 입력 하셈")
            }else if self.txtNicknameBicycle.text?.count == 0{
                ShowAlert(alertmsg: "닉네임 입력 하셈")
            }else{
                
                // 텍스트필드 문자열에서 cleaned Data 추출
                //whitespacesAndNewlines가 뭔지 알아보자ㅏ....
                let numberOfLocker = self.txtNumberOfLocker.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let nicknameBicycle = self.txtNicknameBicycle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                self.addServerData(collection: "bicycle", document: numberOfLocker, bicycleNickname: nicknameBicycle, state: 0, uid: userid)
                
                
                viewFlag = 3
                stackView.isHidden = true
                DispatchQueue.main.async {
                    self.view.addSubview(self.mainviewLabel)
                    self.mainviewLabel.text = "등록이 완료되었습니다."
                    self.mainviewLabel.translatesAutoresizingMaskIntoConstraints = false
                    self.mainviewLabel.topAnchor.constraint(equalTo: self.firstCircleView.bottomAnchor, constant: 40).isActive = true
                    self.mainviewLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                    self.mainviewLabel.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: 60).isActive = true
                }
                
                UIView.animate(
                    withDuration: 1,
                    animations: {
                        self.secondToTirldConstraint.constant = 0
                        self.progressViewWidthConstraint2.constant = 55
                        self.view.layoutIfNeeded()
                    },
                    completion: {_ in
                        self.thirdCircleView.backgroundColor = .black
                    })
                
                nextButton.setTitle("완료", for:.normal)
                
            }
            
        }else if viewFlag == 3 {
            self.dismiss(animated: true)
        }
    }
    
    func ShowAlert(alertmsg: String) {
        // create the alert
        let alert = UIAlertController(title: nil, message: alertmsg, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func addServerData(collection: String, document: String, bicycleNickname: String, state: Int, uid: String){
        db.collection(collection).document(document).setData([
            "bicycleNickname": bicycleNickname,
            "state": state,
            "uid": uid
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

