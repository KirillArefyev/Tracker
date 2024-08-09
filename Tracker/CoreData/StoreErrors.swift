//
//  StoreErrors.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 10.07.2024.
//

import Foundation

enum StoreErrors: Error {
    case decodingErrorInvalidTrackerID
    case decodingErrorInvalidTrackerName
    case decodingErrorInvalidTrackerColor
    case decodingErrorInvalidTrackerEmoji
    case decodingErrorInvalidTrackerSchedule
    case decodingErrorInvalidTrackerCategoryName
    case decodingErrorInvalidTrackerCategoryTrackers
    case decodingErrorInvalidTrackerRecordID
    case decodingErrorInvalidTrackerRecordDate
}
