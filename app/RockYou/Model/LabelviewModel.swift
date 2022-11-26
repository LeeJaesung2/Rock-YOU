//
//  LabelViewModel.swift
//  RockYou
//
//  Created by PC on 2022/11/26.
//

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
