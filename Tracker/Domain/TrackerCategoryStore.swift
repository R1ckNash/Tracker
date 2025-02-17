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
    
    // MARK: - Private Methods
    
    private func fetchTrackerCategoryDTO(by title: String) -> TrackerCategoryCD? {
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
    
    private func convertToTrackerCategory(_ dto: TrackerCategoryCD) -> TrackerCategory {
        let trackers: [Tracker] = (dto.trackers as? Set<TrackerCD>)?
            .compactMap { trackerStore.mapDtoToTracker($0) } ?? []
        return TrackerCategory(title: dto.title ?? "default", trackers: trackers)
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Public Methods
    
    func createTrackerCategory(withTitle title: String) {
        let trackerCategoryDTO = TrackerCategoryCD(context: context)
        trackerCategoryDTO.title = title
        saveContext()
    }
    
    func updateTrackerCategory(withTitle title: String, adding newTracker: Tracker) {
        guard let trackerCategoryDTO = fetchTrackerCategoryDTO(by: title) else {
            print("Tracker category with title \(title) not found.")
            return
        }
        
        let newTrackerDTO = trackerStore.createTrackerDTO(newTracker)
        trackerCategoryDTO.addToTrackers(newTrackerDTO)
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
    
    func fetchTrackerCategory(by title: String) -> TrackerCategory? {
        guard let dto = fetchTrackerCategoryDTO(by: title) else { return nil }
        return convertToTrackerCategory(dto)
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
}
