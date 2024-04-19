//
//  TypeTracker.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 14.04.2024.
//

import Foundation

private let names = ["Категория", "Расписание"]

enum TypeTracker {
    case habit
    case irregularEvent
    
    var title: String {
        switch self {
        case .habit:
            return "Новая привычка"
        case .irregularEvent:
            return "Новое нерегулярное событие"
        }
    }
    
    var heightTable: CGFloat {
        let newHeightTable = CGFloat(numberOfRows * 75)
        switch self {
        case .habit:
            return newHeightTable
        case.irregularEvent:
            return newHeightTable
        }
    }
    
    var cellName: [String] {
        switch self {
        case .habit:
            return names
        case .irregularEvent:
            return ["Категория"]
        }
    }
    
    var numberOfRows: Int {
        let newCellName = cellName.map { $0 }
        switch self {
        case .habit:
            return newCellName.count
        case .irregularEvent:
            return newCellName.count
        }
    }
}
