//
//  PersistentContainer.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 08.08.2024.
//

import CoreData
import Foundation

final class PersistentContainer {
    static let shared = PersistentContainer()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() { }
}
