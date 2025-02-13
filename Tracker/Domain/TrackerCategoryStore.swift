//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Ilia Liasin on 13/02/2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var trackerStore: TrackerStore
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext, trackerStore: TrackerStore) {
        self.context = context
        self.trackerStore = trackerStore
    }
    
    // MARK: - Public Methods
    
    func createTrackerCategory(withTitle title: String) {
        let trackerCategory = TrackerCategoryCD(context: context)
        trackerCategory.title = title
        saveContext()
    }
    
    func updateTrackerCategory(withTitle title: String, adding newTracker: Tracker) {
        guard let trackerCategory = fetchTrackerCategory(by: title) else {
            print("Tracker category with title \(title) not found.")
            return
        }
        let newTrackerCD = trackerStore.createTracker(newTracker)
        trackerCategory.addToTrackers(newTrackerCD)
        saveContext()
    }
    
    func getAllTitles() -> [String] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
        
        do {
            let allCategories = try context.fetch(fetchRequest)
            return allCategories.compactMap { $0.title }
        } catch {
            print("Error during fetching categories: \(error)")
            return []
        }
    }
    
    func fetchTrackerCategory(by title: String) -> TrackerCategoryCD? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error during fetching category with title \(title): \(error)")
            return nil
        }
    }
    
    func convertToCategory(_ trackerCategoriesCD: [TrackerCategoryCD]) -> [TrackerCategory] {
        trackerCategoriesCD.map { categoryCD in
            let trackers = (categoryCD.trackers as? Set<TrackerCD>)?
                .map { trackerStore.convertToTracker($0) } ?? []
            return TrackerCategory(title: categoryCD.title ?? "default", trackers: trackers)
        }
    }
    
    func deleteTrackerCategories() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete tracker categories: \(error)")
        }
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
