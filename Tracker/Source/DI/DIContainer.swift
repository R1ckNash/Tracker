//
//  DIContainer.swift
//  Tracker
//
//  Created by Ilia Liasin on 13/02/2025.
//

import CoreData
import UIKit

final class DIContainer {
    
    // MARK: - Shared Instance
    
    static let shared = DIContainer()
    
    // MARK: - Private Properties
    private let mainContext: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    
    // MARK: - Initializers
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TrackerModel")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        mainContext = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: mainContext,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        
        trackerStore = TrackerStore(context: mainContext, fetchedResultsController: fetchedResultsController)
        trackerCategoryStore = TrackerCategoryStore(context: mainContext)
        trackerRecordStore = TrackerRecordStore(context: mainContext)
    }
    
    // MARK: - Public Methods
    
    func makeDataProvider() -> DataProvider {
        return DataProvider(
            trackerStore: trackerStore,
            trackerCategoryStore: trackerCategoryStore,
            trackerRecordStore: trackerRecordStore
        )
    }
    
    func makeCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel()
    }
    
    func makeScheduleVC() -> ScheduleVC {
        ScheduleVC()
    }
    
    func makeAnalyticsService() -> AnalyticsService {
        AnalyticsService.shared
    }
    
}
