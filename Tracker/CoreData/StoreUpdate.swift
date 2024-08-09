//
//  StoreUpdate.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 10.07.2024.
//

import Foundation

struct StoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}
