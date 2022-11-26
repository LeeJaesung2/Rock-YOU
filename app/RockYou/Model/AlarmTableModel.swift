//
//  AlarmTableModel.swift
//  RockYou
//
//  Created by PC on 2022/11/26.
//

class AlarmTableModel {
    var alarmDatas: [String] = []

    var countOfList: Int {
        return alarmDatas.count
    }
    
    func labelInfo(at index: Int) -> String {
        return alarmDatas[index]
    }
}
