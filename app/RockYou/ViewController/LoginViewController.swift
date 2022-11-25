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

//로그인할 때, uid, id 전역변수 할당
var userid : String = ""
var identification = ""


class LoginViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txtUserId: WLITextField!
    @IBOutlet weak var txtPassword: WLITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                
        loginBtn.layer.cornerRadius = 25
        
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
                    identification = userName
                    guard let uid = document.get("uid") else { return }
                    userid = uid as! String
                    // 비밀번호 필드만 가져오기
                    guard let property = document.get("password") else { return }
                    
                    // 비밀번호 같으면
                    if property as! String == password {
                        // 메인뷰로 화면 전환
                        let mainView = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        
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
    
    func WLITextFielsShowAlertMessage(_ errorMessage: String) {
        self.ShowAlert(alertmsg: errorMessage)
    }
}
