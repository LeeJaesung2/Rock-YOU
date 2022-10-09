//
//  SignUpViewController.swift
//  RockYou
//
//  Created by PC on 2022/10/07.
//

import UIKit

//let strAlertEnterUserName = "ID를 입력하세요"
//let strAlertEnterPassword = "비밀번호를 입력하세요"
let strAlertEnterEmail = "Email을 입력하세요"
let strAlertEnterValidEmail = "올바른 이메일 형식을 입력하세요"
let strAlertEnterPhone = "핸드폰 번호를 입력하세요"
let strAlertSubmit = "등록 완료"

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtUserName: WLITextField!
    @IBOutlet weak var txtPassword: WLITextField!
    @IBOutlet weak var txtEmail: WLITextField!
    @IBOutlet weak var txtPhone: WLITextField!
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        txtUserName.wliDelegate = self
        txtPassword.wliDelegate = self
        txtEmail.wliDelegate = self
        txtPhone.wliDelegate = self

        //set max character limit to allow in textField
        txtPhone.maxCharacter = 11
        
        //set specify character allow into textField
        txtPhone.allowCharacterOnly = "+0123456789"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBord))
        view.addGestureRecognizer(tap)
        
    }
    
    ///Tap on view to dismiss keyboard
    @objc func dismissKeyBord(){
        self.view.endEditing(true)
    }

    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if txtUserName.text?.count == 0 {
            self.ShowAlert(alertmsg: strAlertEnterUserName)
        }else if txtPassword.text?.count == 0 {
            self.ShowAlert(alertmsg: strAlertEnterPassword)
        }else if txtEmail.text?.count == 0 {
            self.ShowAlert(alertmsg: strAlertEnterEmail)
        }else if txtEmail.isValid(txtEmail.text!) == false{
            self.ShowAlert(alertmsg: strAlertEnterValidEmail)
        }else if txtPhone.text?.count == 0 {
            self.ShowAlert(alertmsg:strAlertEnterPhone )
        }else{
            txtUserName.text = ""
            txtPassword.text = ""
            txtEmail.text = ""
            txtPhone.text = ""
            
            // create the alert
            let alert = UIAlertController(title: nil, message: strAlertSubmit, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "loginView") else { return }
                nextVC.modalPresentationStyle = .fullScreen
                self.dismiss(animated: true){
                    self.present(nextVC, animated: true)
                }
            })
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Show alert controller
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
extension SignUpViewController: WLITextFieldDelegate{
    
    
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
