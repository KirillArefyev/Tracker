//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 11.04.2024.
//

import Foundation

struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
}
// Mocks для проверки фильтра
struct CategoriesMock {
    static let shared = CategoriesMock()
    
    private init() { }
    
    let categories: [TrackerCategory] = [TrackerCategory(name: "Первая категория",
                                                         
                                                         trackers: [Tracker(id: UUID(),
                                                                            name: "Раз",
                                                                            color: .color1,
                                                                            emoji: "👨‍💻",
                                                                            schedule: [WeekDay.monday,
                                                                                       WeekDay.thursday,
                                                                                       WeekDay.friday]),
                                                                    
                                                                    Tracker(id: UUID(),
                                                                            name: "Два",
                                                                            color: .color2,
                                                                            emoji: "🤔",
                                                                            schedule: [WeekDay.wednesday])
                                                         ]),
                                         
                                         TrackerCategory(name: "Вторая категория",
                                                         
                                                         trackers: [Tracker(id: UUID(),
                                                                            name: "Три",
                                                                            color: .color3,
                                                                            emoji: "🤯",
                                                                            schedule: [WeekDay.sunday,
                                                                                       WeekDay.monday,
                                                                                       WeekDay.tuesday,
                                                                                       WeekDay.wednesday,
                                                                                       WeekDay.thursday,
                                                                                       WeekDay.friday,
                                                                                       WeekDay.saturday]),
                                                                    
                                                                    Tracker(id: UUID(),
                                                                            name: "Четыре",
                                                                            color: .color4,
                                                                            emoji: "😇",
                                                                            schedule: [WeekDay.saturday]),
                                                                    
                                                                    Tracker(id: UUID(),
                                                                            name: "Пять",
                                                                            color: .color5,
                                                                            emoji: "🥶",
                                                                            schedule: [WeekDay.friday,
                                                                                       WeekDay.sunday])
                                                         ])]
}
