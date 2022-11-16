//
//  ViewController.swift
//  RockYou
//
//  Created by PC on 2022/10/05.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

let strAlertEnterUserName = "ID를 입력하세요"
let strAlertEnterPassword = "비밀번호를 입력하세요"

class LoginViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txtUserId: WLITextField!
    @IBOutlet weak var txtPassword: WLITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(red: 45, green: 45, blue: 45, alpha: 1)
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                
        txtUserId.wliDelegate = self
        txtPassword.wliDelegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBord))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        txtUserId.text = ""
        txtPassword.text = ""
    }
    
    //회원가입 버튼
    @IBAction func goSignUpBtn(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpView") else { return }
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    ///Tap on view to dismiss keyboard
    @objc func dismissKeyBord(){
        self.view.endEditing(true)
    }

    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if txtUserId.text?.count == 0 {
            self.ShowAlert(alertmsg: strAlertEnterUserName)
        }else if txtPassword.text?.count == 0 {
            self.ShowAlert(alertmsg: strAlertEnterPassword)
        }else{
            
            // 텍스트필드 문자열에서 cleaned Data 추출
            let userName = txtUserId.text!.trimmingCharacters(in: .whitespacesAndNewlines) //whitespacesAndNewlines가 뭔지 알아보자ㅏ....
            let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // get user document
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userName)
            
            ref.getDocument { (document, error) in
                // 존재 한다면
                if let document = document, document.exists {
                    // 비밀번호 필드만 가져오기
                    guard let property = document.get("password") else { return }
                    print(type(of: property))
                    print(type(of: password))
                    
                    // 비밀번호 같으면
                    if property as! String == password {
                        // 메인뷰로 화면 전환
                        let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                        
                        // 뷰전환 애니메이션
                        guard let window = self.view.window else { return }
                        let transition = CATransition()
                        transition.type = .reveal
                        transition.duration = 0.3
                        window.layer.add(transition, forKey: kCATransition)
                        
                        self.view.window?.rootViewController = mainView
                        self.view.window?.makeKeyAndVisible()
                    }else{
                        self.txtPassword.text = ""
                        self.ShowAlert(alertmsg: "비밀번호를 확인해주세요")
                    }
                    //전체 다큐먼트 들고오기
                    //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    //print("Document data: \(dataDescription)")

                } else {
                    self.ShowAlert(alertmsg: "등록되지 않은 사용자입니다")
                 }
            }
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
}

// MARK: - set WLITextField delegate method
extension LoginViewController: WLITextFieldDelegate{
    
    
    func WLITextFieldDidBeginEditing(_ textField: UITextField) {
        print("WLITextFieldDidBeginEditing")
    }
    func WLITextFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("WLITextFieldDidEndEditing")
    }
    
    func WLITextFielsShowAlertMessage(_ errorMessage: String) {
        self.ShowAlert(alertmsg: errorMessage)
    }
}
