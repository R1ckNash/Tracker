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
    
    // MARK: - Initializer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TrackerModel")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        mainContext = persistentContainer.viewContext
        
        trackerStore = TrackerStore(context: mainContext)
        trackerCategoryStore = TrackerCategoryStore(context: mainContext, trackerStore: trackerStore)
        trackerRecordStore = TrackerRecordStore(context: mainContext, trackerStore: trackerStore)
    }
    
    // MARK: - Factory Method
    
    func makeDataProvider(trackerCollection: UICollectionView? = nil) -> DataProvider {
        
        return DataProvider(context: mainContext,
                            trackerStore: trackerStore,
                            trackerCategoryStore: trackerCategoryStore,
                            trackerRecordStore: trackerRecordStore,
                            trackerCollection: trackerCollection)
    }
}
