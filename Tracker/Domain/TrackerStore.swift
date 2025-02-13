//
//  TrackerStore.swift
//  Tracker
//
//  Created by Ilia Liasin on 13/02/2025.
//

import CoreData
import UIKit

final class TrackerStore {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func createTracker(_ tracker: Tracker) -> TrackerCD {
        let trackerCD = TrackerCD(context: context)
        trackerCD.id = tracker.id
        trackerCD.name = tracker.name
        trackerCD.emoji = tracker.emoji
        trackerCD.color = tracker.color
        
        tracker.schedule?.forEach { date in
            let scheduleEntry = ScheduleCD(context: context)
            scheduleEntry.value = date
            scheduleEntry.tracker = trackerCD
        }
        
        saveContext()
        return trackerCD
    }
    
    func fetchTracker(by id: UUID) -> TrackerCD? {
        let fetchRequest: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching tracker by id: \(error)")
            return nil
        }
    }
    
    func convertToTracker(_ trackerCD: TrackerCD) -> Tracker {
        let schedule: [String] = (trackerCD.schedule as? Set<ScheduleCD>)?
            .compactMap { $0.value } ?? []
        
        return Tracker(
            id: trackerCD.id ?? UUID(),
            name: trackerCD.name ?? "default",
            color: trackerCD.color as? UIColor ?? .orange,
            emoji: trackerCD.emoji ?? "🫡",
            schedule: schedule
        )
    }
    
    func deleteTrackers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete trackers: \(error)")
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
