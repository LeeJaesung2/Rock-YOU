//
//  BikeListViewController.swift
//  RockYou
//
//  Created by PC on 2022/10/12.
//

import UIKit
import FirebaseAuth

struct LabelInfo {
    let nickname: String
    let idnum: String
    let state: String
    let viewColor: UIColor
    let labelColor: UIColor
    
    init (nickname: String, idnum: String, state: String, viewColor: UIColor, labelColor: UIColor) {
        self.nickname = nickname
        self.idnum = idnum
        self.state = state
        self.viewColor = viewColor
        self.labelColor = labelColor
    }
}

class MainViewController: UIViewController{
        
    let viewModel = LabelViewModel()
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
       
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        // Do you your api calls in here, and then asynchronously remember to stop the
        // refreshing when you've got a result (either positive or negative)
        DispatchQueue.main.asyncAfter(deadline:.now()+1.5) {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    @IBAction func bicycleRegisterBtnDidTap(_ sender: Any) {
        // 등록 버튼 클릭
        guard let regVC = self.storyboard?.instantiateViewController(withIdentifier: "BicycleRegisterViewController") as? BicycleRegisterViewController else { return }
        regVC.modalPresentationStyle = .fullScreen
        self.present(regVC, animated: true)
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
        stateColorView.backgroundColor = info.viewColor
        stateLabel.textColor = info.labelColor
        
        nicknameLabel.sizeToFit()
        
        stateColorView.layer.cornerRadius = 10
        stateColorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}

// view model
class LabelViewModel {
     // db에서 정보 받아와서 if문으로 color 정해줘야 함
    // 지금은 임의로 값 넣은거임
    let labelInfoList: [LabelInfo] = [
        LabelInfo(nickname: "페가 수스", idnum:"QCR23TVM17A", state:"주행중", viewColor: .white, labelColor:.black),
        LabelInfo(nickname: "레드 불", idnum: "QCR23TVM17A", state: "잠금중", viewColor: .yellow, labelColor:.black),
        LabelInfo(nickname: "람보르기니", idnum: "QCR23TVM17A", state: "도난", viewColor: .red, labelColor:.red),
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
