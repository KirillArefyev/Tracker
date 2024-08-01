//
//  WeekDayMarshalling.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 26.06.2024.
//

import Foundation

final class WeekDayMarshalling {
    func getString(from schedule: [WeekDay]) -> String {
        let string = String(describing: schedule.map { String($0.rawValue) }.joined(separator: ", ") )
        return string
    }
    
    func getWeekDay(from string: String) -> [WeekDay] {
        let components = string.components(separatedBy: ", ").compactMap { Int($0) }
        let schedule = components.compactMap { WeekDay(rawValue: $0) }
        return schedule
    }
}
