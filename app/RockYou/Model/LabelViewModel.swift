//
//  LabelviewData.swift
//  RockYou
//
//  Created by PC on 2022/11/26.
//

import UIKit

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

// view model
class LabelViewModel {
    var labelInfoList: [LabelInfo] = []

    var countOfList: Int {
        return labelInfoList.count
    }
    
    func labelInfo(at index: Int) -> LabelInfo {
        return labelInfoList[index]
    }
}
