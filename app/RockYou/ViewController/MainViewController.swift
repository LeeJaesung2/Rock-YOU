//
//  BikeListViewController.swift
//  RockYou
//
//  Created by PC on 2022/10/12.
//

import UIKit

struct LabelInfo {
    let nickname: String
    let idnum: String
    let state: String
    //let color: CGColor
    
    init (nickname: String, idnum: String, state: String) {
        self.nickname = nickname
        self.idnum = idnum
        self.state = state
        //self.color = color
    }
}

class MainViewController: UIViewController{
        
    let viewModel = LabelViewModel()
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


class Cell: UICollectionViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var idnumLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateColorView: UIView!
    
    func update(info: LabelInfo) {
        nicknameLabel.text = info.nickname
        idnumLabel.text = info.idnum
        stateLabel.text = info.state
        
        nicknameLabel.sizeToFit()
        
        stateColorView.layer.cornerRadius = 10
        stateColorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if(info.state == "주행중"){
            stateColorView.backgroundColor = UIColor.yellow
        }
        else if(info.state == "도난"){
            stateColorView.backgroundColor = UIColor.red
            stateLabel.textColor = .red
        }
    }
    
}

// view model
class LabelViewModel {
    let labelInfoList: [LabelInfo] = [
        LabelInfo(nickname: "페가 수스", idnum:"QCR23TVM17A", state:"주행중"),
        LabelInfo(nickname: "레드 불", idnum: "QCR23TVM17A", state: "잠금중"),
        LabelInfo(nickname: "람보르기니", idnum: "QCR23TVM17A", state: "도난"),
    ]

    var countOfList: Int {
        return labelInfoList.count
    }
    
    func labelInfo(at index: Int) -> LabelInfo {
        return labelInfoList[index]
    }
}

//컬렉션뷰 함수 모아둠
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        let labelInfo = viewModel.labelInfo(at: indexPath.item)
        cell.update(info: labelInfo)
        return cell
    }
    
    //컬렉션 뷰 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        //let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 1
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        //let itemsPerColumn: CGFloat = 2
        //let heightPadding = sectionInsets.top * (itemsPerColumn + 10)
        let cellWidth = ((width - widthPadding) / itemsPerRow)-40
        //let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: 100)
    }
        
    
    //셀 클릭 이밴트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        performSegue(withIdentifier: "showSegue", sender: cell)
    }
    
}
