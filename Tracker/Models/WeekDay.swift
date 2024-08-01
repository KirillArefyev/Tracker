//
//  WeekDay.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 14.04.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    case monday = 2, tuesday = 3, wednesday = 4, thursday = 5, friday = 6, saturday = 7, sunday = 1
    
    var fullName: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    var shortName: (Int,String) {
        switch self {
        case .monday:
            return (1, "Пн")
        case .tuesday:
            return (2, "Вт")
        case .wednesday:
            return (3, "Ср")
        case .thursday:
            return (4, "Чт")
        case .friday:
            return (5, "Пт")
        case .saturday:
            return (6, "Сб")
        case .sunday:
            return (7, "Вс")
        }
    }
}
