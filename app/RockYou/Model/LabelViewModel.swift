//
//  LabelviewData.swift
//  RockYou
//
//  Created by PC on 2022/11/26.
//

import UIKit

struct LabelData {
    let nickName: String
    let idNum: String
    let state: String
    let viewColor: UIColor
    let labelColor: UIColor
    
    init (nickName: String, idNum: String, state: String, viewColor: UIColor, labelColor: UIColor) {
        self.nickName = nickName
        self.idNum = idNum
        self.state = state
        self.viewColor = viewColor
        self.labelColor = labelColor
    }
}

// view model
class LabelViewModel {
    var labelDataList: [LabelData] = []

    var countOfList: Int {
        return labelDataList.count
    }
    
    func labelInfo(at index: Int) -> LabelData {
        return labelDataList[index]
    }
}
