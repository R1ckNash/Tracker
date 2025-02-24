//
//  DataProvider.swift
//  Tracker
//
//  Created by Ilia Liasin on 13/02/2025.
//

import Foundation
import UIKit

final class DataProvider: NSObject {
    
    // MARK: - Private Properties
    
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    
    // MARK: - Initializers
    
    init(trackerStore: TrackerStore,
         trackerCategoryStore: TrackerCategoryStore,
         trackerRecordStore: TrackerRecordStore) {
        
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        super.init()
    }
    
    // MARK: - Public Methods
    
    func performFetchByDay(for dayOfWeek: String) {
        trackerStore.performFetchByDay(for: dayOfWeek)
    }
    
    func getNumberOfSections() -> Int {
        trackerStore.getNumberOfSections()
    }
    
    func getNumberOfItems(inSection section: Int) -> Int {
        trackerStore.getNumberOfItems(inSection: section)
    }
    
    func category(for sectionIndex: Int) -> String? {
        trackerStore.category(for: sectionIndex)
    }
    
    // MARK: - Tracker Methods
    
    func createTracker(tracker: Tracker) -> Tracker {
        trackerStore.createTracker(tracker)
    }
    
    func getTracker(by id: UUID) -> Tracker {
        guard let tracker = trackerStore.fetchTracker(by: id) else {
            fatalError("Tracker not found")
        }
        
        return tracker
    }
    
    func deleteTracker(by id: UUID) {
        trackerStore.deleteTracker(by: id)
    }
    
    func getTracker(at indexPath: IndexPath) -> Tracker {
        trackerStore.fetchTracker(at: indexPath)
    }
    
    // MARK: - Tracker Category Methods
    
    func createTrackerCategory(categoryTitle: String) {
        trackerCategoryStore.createTrackerCategory(withTitle: categoryTitle)
    }
    
    func updateTrackerCategory(title: String, newTracker: Tracker) {
        trackerCategoryStore.updateTrackerCategory(withTitle: title, adding: newTracker)
    }
    
    func getAllCategoryTitles() -> [String] {
        trackerCategoryStore.getAllCategoryTitles()
    }
    
    func getTrackerCategory(by title: String) -> TrackerCategory? {
        trackerCategoryStore.fetchTrackerCategory(by: title)
    }
    
    // MARK: - Record Methods
    
    func createRecord(with id: UUID, for date: Date) {
        trackerRecordStore.createRecord(for: id, on: date)
    }
    
    func deleteRecord(with id: UUID, for date: Date) {
        do {
            try trackerRecordStore.deleteRecord(for: id, on: date)
        } catch {
            print("Error deleting record: \(error)")
        }
    }
    
    func isRecordExist(for id: UUID, on date: Date) -> Bool {
        trackerRecordStore.isRecordExist(for: id, on: date)
    }
    
    func getCompleteDaysCount(for id: UUID) -> Int {
        trackerRecordStore.completeDaysCount(for: id)
    }
}

