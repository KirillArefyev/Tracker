//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 11.04.2024.
//

import Foundation

struct TrackerCategory {
    let categoryName: String
    let trackers: [Tracker] = [Tracker(id: UUID(),
                                       name: "Раз",
                                       color: .color1,
                                       emoji: "🤔",
                                       schedule: []
                                      )]
}
