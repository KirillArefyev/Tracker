//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 12.06.2024.
//

import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    // MARK: - Public Properties
    var records: Set<TrackerRecord> {
        guard
            let object = fetchedResultsController.fetchedObjects,
            let records = try? object.map({ try readTrackerRecord(from: $0) })
        else { return [] }
        let recordsSet = Set(records)
        return recordsSet
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
        ]
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    // MARK: - Inits
    convenience override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func createTrackerRecord(from record: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.recordID = record.id
        trackerRecordCoreData.date = record.date
        saveContext()
    }
    
    func readTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.recordID else { throw StoreErrors.decodingErrorInvalidTrackerRecordID }
        guard let date = trackerRecordCoreData.date else { throw StoreErrors.decodingErrorInvalidTrackerRecordDate }
        let record = TrackerRecord(id: id, date: date)
        return record
    }
    
    func deleteTrackerRecord(with id: UUID) throws {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.recordID), id.uuidString)
        let recordsCoreData = try context.fetch(fetchRequest)
        
        if let record = recordsCoreData.first {
            context.delete(record)
        }
        saveContext()
    }
    
    // MARK: - Private Methods
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
