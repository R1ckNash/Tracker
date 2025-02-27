//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ilia Liasin on 13/02/2025.
//

import CoreData
import UIKit

final class TrackerRecordStore {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
    
    private func fetchTrackerDTO(by id: UUID) -> TrackerCD? {
        let fetchRequest: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching tracker DTO by id: \(error)")
            return nil
        }
    }
    
    // MARK: - Public Methods
    
    func getTotalCompletedTrackersCount() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        do {
            return try context.count(for: fetchRequest)
        } catch {
            print("Error counting tracker records: \(error)")
            return 0
        }
    }
    
    func createRecord(for trackerId: UUID, on date: Date) {
        guard let trackerDTO = fetchTrackerDTO(by: trackerId) else {
            print("Error: Tracker with id \(trackerId) not found.")
            return
        }
        
        let newRecordDTO = TrackerRecordCD(context: context)
        newRecordDTO.date = date
        newRecordDTO.tracker = trackerDTO
        saveContext()
    }
    
    
    func isRecordExist(for trackerId: UUID, on date: Date) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", trackerId as CVarArg, date as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch record for tracker id \(trackerId) on date \(date): \(error)")
            return false
        }
    }
    
    
    func completeDaysCount(for trackerId: UUID) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@", trackerId as CVarArg)
        
        do {
            return try context.count(for: fetchRequest)
        } catch {
            print("Failed to count complete days for tracker id \(trackerId): \(error)")
            return 0
        }
    }
    
    
    func deleteRecord(for trackerId: UUID, on date: Date) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", trackerId as CVarArg, date as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let recordToDelete = results.first else {
                print("No record found for tracker id \(trackerId) on date \(date)")
                return
            }
            context.delete(recordToDelete)
            saveContext()
        } catch {
            throw error
        }
    }
    
    
    func deleteAllRecords() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete tracker records: \(error)")
        }
    }
    
}
