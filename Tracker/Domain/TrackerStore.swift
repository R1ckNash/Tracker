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
    private var fetchedResultsController: NSFetchedResultsController<TrackerCD>
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext, fetchedResultsController: NSFetchedResultsController<TrackerCD>) {
        self.context = context
        self.fetchedResultsController = fetchedResultsController
    }
    
    // MARK: - Private Methods
    
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to update fetch request: \(error)")
        }
    }
    
    private func mapDtoToTracker(_ trackerDto: TrackerCD) -> Tracker {
        let schedule: [String] = (trackerDto.schedule as? Set<ScheduleCD>)?
            .compactMap { $0.value } ?? []
        
        return Tracker(id: trackerDto.id ?? UUID(),
                       name: trackerDto.name ?? "default",
                       color: trackerDto.color as? UIColor ?? .orange,
                       emoji: trackerDto.emoji ?? "🫡",
                       schedule: schedule
        )
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
    
    private func createTrackerDTO(_ tracker: Tracker) -> TrackerCD {
        let trackerDTO = TrackerCD(context: context)
        trackerDTO.id = tracker.id
        trackerDTO.name = tracker.name
        trackerDTO.emoji = tracker.emoji
        trackerDTO.color = tracker.color
        
        tracker.schedule.forEach { day in
            let scheduleEntry = ScheduleCD(context: context)
            scheduleEntry.value = day
            scheduleEntry.tracker = trackerDTO
        }
        
        saveContext()
        return trackerDTO
    }
    
    // MARK: - Public Methods
    
    func performFetchByDay(for dayOfWeek: String) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "schedule.@count == 0 OR ANY schedule.value == %@", dayOfWeek
        )
        fetch()
    }
    
    func getNumberOfSections() -> Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func getNumberOfItems(inSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func category(for sectionIndex: Int) -> String? {
        guard let sections = fetchedResultsController.sections,
              sectionIndex < sections.count else {
            return nil
        }
        let firstObject = fetchedResultsController.object(at: IndexPath(row: 0, section: sectionIndex))
        return firstObject.category?.title
    }
    
    @discardableResult
    func createTracker(_ tracker: Tracker) -> Tracker {
        let trackerDTO = createTrackerDTO(tracker)
        return mapDtoToTracker(trackerDTO)
    }
    
    func fetchTracker(by id: UUID) -> Tracker? {
        guard let trackerDTO = fetchTrackerDTO(by: id) else { return nil }
        return mapDtoToTracker(trackerDTO)
    }
    
    func updateTracker(_ tracker: Tracker) {
        guard let trackerDTO = fetchTrackerDTO(by: tracker.id) else {
            print("Tracker with id \(tracker.id) not found for update")
            return
        }
        trackerDTO.name = tracker.name
        trackerDTO.emoji = tracker.emoji
        trackerDTO.color = tracker.color
        
        if let scheduleSet = trackerDTO.schedule as? Set<ScheduleCD> {
            for scheduleEntry in scheduleSet {
                context.delete(scheduleEntry)
            }
        }
        
        for day in tracker.schedule {
            let scheduleEntry = ScheduleCD(context: context)
            scheduleEntry.value = day
            scheduleEntry.tracker = trackerDTO
        }
        saveContext()
    }
    
    func getTrackerCategoryName(by id: UUID) -> String? {
        guard let trackerDTO = fetchTrackerDTO(by: id) else { return nil }
        return trackerDTO.category?.title
    }
    
    func fetchTracker(at indexPath: IndexPath) -> Tracker {
        mapDtoToTracker(fetchedResultsController.object(at: indexPath))
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
    
    func deleteTracker(by id: UUID) {
        guard let trackerDto = fetchTrackerDTO(by: id) else {
            print("Tracker with id \(id) not found for deletion.")
            return
        }
        
        if let categoryDto = trackerDto.category,
           categoryDto.trackers?.count == 1 {
            context.delete(categoryDto)
        }
        
        context.delete(trackerDto)
        saveContext()
    }
    
}
