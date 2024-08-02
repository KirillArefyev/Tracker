//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 12.06.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    // MARK: - Public Properties
    var categories: [TrackerCategory] {
        guard
            let objects = fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.readTrackerCategory(from: $0) })
        else { return [] }
        return categories
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<StoreUpdate.Move>?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func createCategory(with tracker: Tracker, and name: String) throws {
        let trackerCoreData = try trackerStore.createTracker(from: tracker)
        
        if let oldCategory = try fetchCategory(with: name) {
            guard let oldTrackers = oldCategory.trackers,
                  var oldTrackersCoreData = oldTrackers.allObjects as? [TrackerCoreData]
            else { return }
            oldTrackersCoreData.append(trackerCoreData)
            oldCategory.trackers = NSSet(array: oldTrackersCoreData)
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.name = name
            newCategory.trackers = NSSet(array: [trackerCoreData])
        }
        saveContext()
    }
    
    func readTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let categoryName = trackerCategoryCoreData.name else { throw StoreErrors.decodingErrorInvalidTrackerCategoryName }
        let categoryTrackers = trackerStore.trackers
        let trackerCategory = TrackerCategory(name: categoryName,
                                              trackers: categoryTrackers
                                              )
        return trackerCategory
    }
    
    func deleteTrackerCategory(with categoryName: String) throws {
        let fetchRequest = self.fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), categoryName)
        let categoriesCoreData = try context.fetch(fetchRequest)
        
        if let deletedCategory = categoriesCoreData.first {
            context.delete(deletedCategory)
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
    
    private func fetchCategory(with name: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", name])
        let categoriesCoreData = try context.fetch(fetchRequest)
        let category = categoriesCoreData.first
        return category
    }
}

// MARK: - Extensions
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        case .move:
            if let oldIndexPath = indexPath,
               let newIndexPath = newIndexPath {
                movedIndexes?.insert(
                    .init(oldIndex: oldIndexPath.item,
                          newIndex: newIndexPath.item
                         )
                )
            }
        case .update:
            if let indexPath = indexPath {
                updatedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
