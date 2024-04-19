//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 11.04.2024.
//

import Foundation

struct TrackerCategory {
    let categoryName: String
    let trackers: [Tracker]
    
    init(categoryName: String, trackers: [Tracker]) {
        self.categoryName = "Важное"
        self.trackers = [Tracker(id: UUID(), name: "Раз", color: .color1, emoji: "🙂", schedule: []),
                         Tracker(id: UUID(), name: "Два", color: .color2, emoji: "😻", schedule: []),
                         Tracker(id: UUID(), name: "Три", color: .color3, emoji: "🌺", schedule: []),
                         Tracker(id: UUID(), name: "Четыре четыре четыре четыре", color: .color4, emoji: "🐶", schedule: [])
        ]
    }
}
