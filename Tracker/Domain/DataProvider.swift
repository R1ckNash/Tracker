//
//  DataProvider.swift
//  Tracker
//
//  Created by Ilia Liasin on 13/02/2025.
//

import Foundation
import UIKit
import CoreData

final class DataProvider: NSObject {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCD>!
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    private weak var trackerCollection: UICollectionView?
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext,
         trackerStore: TrackerStore,
         trackerCategoryStore: TrackerCategoryStore,
         trackerRecordStore: TrackerRecordStore,
         trackerCollection: UICollectionView? = nil) {
        
        self.context = context
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.trackerCollection = trackerCollection
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Private Methods
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
    }
    
    // MARK: - Public Methods
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    func performFetchByDay(for dayOfWeek: String) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "ANY schedule.value == %@", dayOfWeek
        )
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to update fetch request: \(error)")
        }
    }
    
    func numberOfSections() -> Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfItems(inSection section: Int) -> Int {
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
    
    func object(at indexPath: IndexPath) -> Tracker {
        trackerStore.convertToTracker(fetchedResultsController.object(at: indexPath))
    }
    
    func deleteAllData() {
        trackerCategoryStore.deleteTrackerCategories()
        trackerStore.deleteTrackers()
        trackerRecordStore.deleteAllRecords()
    }
    
    // MARK: - Tracker Methods
    
    func createTracker(tracker: Tracker) -> TrackerCD {
        trackerStore.createTracker(tracker)
    }
    
    func fetchTracker(by id: UUID) -> TrackerCD? {
        trackerStore.fetchTracker(by: id)
    }
    
    // MARK: - Tracker Category Methods
    
    func createTrackerCategory(categoryTitle: String) {
        trackerCategoryStore.createTrackerCategory(withTitle: categoryTitle)
    }
    
    func updateTrackerCategory(title: String, newTracker: Tracker) {
        trackerCategoryStore.updateTrackerCategory(withTitle: title, adding: newTracker)
    }
    
    func getAllPossibleTitles() -> [String] {
        trackerCategoryStore.getAllTitles()
    }
    
    func fetchTrackerCategory(by title: String) -> TrackerCategoryCD? {
        trackerCategoryStore.fetchTrackerCategory(by: title)
    }
    
    // MARK: - Record Methods
    
    func createRecord(with id: UUID, for date: Date) {
        trackerRecordStore.createRecord(for: id, on: date)
    }
    
    func deleteRecord(with id: UUID, for date: Date) throws {
        do {
            try trackerRecordStore.deleteRecord(for: id, on: date)
        } catch {
            print("Error deleting record: \(error)")
        }
    }
    
    func checkRecordExist(with id: UUID, at date: Date) -> Bool {
        trackerRecordStore.isRecordExist(for: id, on: date)
    }
    
    func getCompleteDays(for id: UUID) -> Int {
        trackerRecordStore.completeDaysCount(for: id)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension DataProvider: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        guard let trackerCollection = trackerCollection else { return }
        
        switch type {
        case .insert:
            trackerCollection.insertSections(indexSet)
        case .delete:
            if let indexPath = indexPath {
                trackerCollection.deleteItems(at: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                trackerCollection.reloadItems(at: [indexPath])
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                trackerCollection.moveItem(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            fatalError("Unknown change type in NSFetchedResultsControllerDelegate.")
        }
    }
}
