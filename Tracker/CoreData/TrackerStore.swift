//
//  TrackerStore.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 12.06.2024.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    // MARK: - Public Properties
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.readTracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    // MARK: - Inits
    convenience override init() {
        let container = PersistentContainer.shared
        let context = container.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func createTracker(from tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        return trackerCoreData
    }
    
    func readTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.trackerID else { throw StoreErrors.decodingErrorInvalidTrackerID }
        guard let name = trackerCoreData.name else { throw StoreErrors.decodingErrorInvalidTrackerName }
        guard let emoji = trackerCoreData.emoji else { throw StoreErrors.decodingErrorInvalidTrackerEmoji }
        guard let color = trackerCoreData.color else { throw StoreErrors.decodingErrorInvalidTrackerColor }
        guard let schedule = trackerCoreData.schedule else { throw StoreErrors.decodingErrorInvalidTrackerSchedule }
        
        let tracker = Tracker(id: id,
                              name: name,
                              color: (color as? UIColor) ?? UIColor(),
                              emoji: emoji,
                              schedule: (schedule as? [WeekDay]) ?? []
        )
        return tracker
    }
    
    func updateTracker(with id: UUID) throws {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), id.uuidString)
        let trackersCoreData = try context.fetch(fetchRequest)
        
        if let oldTracker = trackersCoreData.first {
            let newTracker = TrackerCoreData(context: context)
            oldTracker.name = newTracker.name
            oldTracker.color = newTracker.color
            oldTracker.emoji = newTracker.emoji
            oldTracker.schedule = newTracker.schedule
        }
        saveContext()
    }
    
    func deleteTracker(with id: UUID) throws {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), id.uuidString)
        let trackersCoreData = try context.fetch(fetchRequest)
        
        if let deletedTracker = trackersCoreData.first {
            context.delete(deletedTracker)
        }
        saveContext()
    }
    
    func fetchTracker(with id: UUID) throws -> TrackerCoreData? {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), id.uuidString)
        let trackerCoreData = try context.fetch(fetchRequest)
        let tracker = trackerCoreData.first
        return tracker
    }
    
    // MARK: - Private Methods
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

// MARK: - Extensions
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
