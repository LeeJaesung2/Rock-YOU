//
//  MapViewController.swift
//  RockYou
//
//  Created by PC on 2022/10/16.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        let ref = db.collection("users").document(userName)
        
        ref.getDocument { (document, error) in
            // 존재 한다면
            if let document = document, document.exists {
                // 비밀번호 필드만 가져오기
                guard let property = document.get("password") else { return }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
