//
//  Date+Extension.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 12.04.2024.
//

import Foundation

extension Date {
    func makeShortDate() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        guard let date = calendar.date(from: components) else { return Date() }
        return date
    }
}
