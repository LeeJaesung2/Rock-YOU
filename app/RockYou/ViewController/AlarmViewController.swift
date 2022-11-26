//
//  AlarmViewController.swift
//  RockYou
//
//  Created by PC on 2022/11/16.
//

import UIKit

let viewModel = AlarmTableModel()

class AlarmViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = 40
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableview.delegate = self
        tableview.dataSource = self
        
        viewModel.alarmDatas.append("1")
        viewModel.alarmDatas.append("2")
        viewModel.alarmDatas.append("3")
    }
    
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.labelInfo(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
          if editingStyle == .delete {
              
              viewModel.alarmDatas.remove(at: indexPath.row)
              tableView.deleteRows(at: [indexPath], with: .fade)
              
          } else if editingStyle == .insert{}
    }
}
