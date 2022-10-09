//
//  ViewController.swift
//  RockYou
//
//  Created by PC on 2022/10/05.
//

import UIKit

let strAlertEnterUserName = "ID를 입력하세요"
let strAlertEnterPassword = "비밀번호를 입력하세요"

class ViewController: UIViewController {

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
extension ViewController: WLITextFieldDelegate{
    
    
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
