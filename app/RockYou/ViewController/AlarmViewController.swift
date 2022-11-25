//
//  AlarmViewController.swift
//  RockYou
//
//  Created by PC on 2022/11/16.
//

import UIKit

var tableItems: [String] = [
    "1",
    "2",
    "3"
]

class AlarmViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    
    

}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
          if editingStyle == .delete {
              
              tableItems.remove(at: indexPath.row)
              tableView.deleteRows(at: [indexPath], with: .fade)
              
          } else if editingStyle == .insert{}
    }
    
}
