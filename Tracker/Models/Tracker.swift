//
//  Tracker.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 11.04.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [TrackerSchedule]?
}
