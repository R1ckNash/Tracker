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
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    
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
        loadCategories()
    }
    
    func loadCategories() {
        categories = trackerCategoryStore.fetchAllCategories()
        visibleCategories = categories
    }
    
    func filterCategories(with searchText: String?) {
        guard let text = searchText, !text.isEmpty else {
            visibleCategories = categories
            return
        }
        
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.name.lowercased().contains(text.lowercased())
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }
    
    func getNumberOfSections() -> Int {
        visibleCategories.count
    }
    
    func getNumberOfItems(inSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func category(for sectionIndex: Int) -> String? {
        visibleCategories[sectionIndex].title
    }
    
    // MARK: - Pin
    
    func isTrackerPinned(for id: UUID) -> Bool {
        guard let pinnedCategory = getTrackerCategory(by: Constants.pinned) else { return false }
        return pinnedCategory.trackers.contains(where: { $0.id == id })
    }
    
    func pinTracker(with id: UUID) {
        let tracker = getTracker(by: id)
        trackerCategoryStore.addTrackerToPinned(tracker)
    }
    
    func unpinTracker(with id: UUID) {
        trackerCategoryStore.removeTrackerFromPinned(with: id)
    }
    
    // MARK: - Tracker Methods
    
    func createTracker(tracker: Tracker) -> Tracker {
        trackerStore.createTracker(tracker)
    }
    
    func updateTracker(_ tracker: Tracker) {
        trackerStore.updateTracker(tracker)
    }
    
    func trackerExists(with id: UUID) -> Bool {
        trackerStore.fetchTracker(by: id) != nil
    }
    
    func getTracker(by id: UUID) -> Tracker {
        guard let tracker = trackerStore.fetchTracker(by: id) else {
            fatalError("Tracker not found")
        }
        
        return tracker
    }
    
    func getTrackerCategoryName(by id: UUID) -> String {
        guard let categoryName = trackerStore.getTrackerCategoryName(by: id) else {
            fatalError("Tracker category not found")
        }
        return categoryName
    }
    
    func deleteTracker(by id: UUID) {
        trackerStore.deleteTracker(by: id)
    }
    
    func getTracker(at indexPath: IndexPath) -> Tracker {
        visibleCategories[indexPath.section].trackers[indexPath.item]
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

