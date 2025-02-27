//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Ilia Liasin on 24/02/2025.
//

import Foundation

final class UserDefaultsService {
    
    // MARK: - Public Properties
    
    static let shared = UserDefaultsService()
    
    // MARK: - Private Properties
    
    private let dataStorage = UserDefaults.standard
    
    // MARK: - Public Methods
    
    func setOnboardingCompleted() {
        dataStorage.set(true, forKey: "isOnboardingCompleted")
    }
    
    func isOnboardingCompleted() -> Bool {
        dataStorage.bool(forKey: "isOnboardingCompleted")
    }

}
