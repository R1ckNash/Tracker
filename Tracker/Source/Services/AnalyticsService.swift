//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Ilia Liasin on 27/02/2025.
//

import AppMetricaCore

enum AnalyticsEvent: String {
    case open
    case close
    case click
}

enum AnalyticsItem: String {
    case addTrack = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}

final class AnalyticsService {
    
    // MARK: - Public Properties
    
    static let shared = AnalyticsService()
    
    // MARK: - Public Methods
    
    func report(event: AnalyticsEvent, item: AnalyticsItem? = nil, screen: String = "TrackerVC") {
        var parameters: [String: String] = [
            "event": event.rawValue,
            "screen": screen
        ]
        if let item = item {
            parameters["item"] = item.rawValue
        }
        
        AppMetrica.reportEvent(name: event.rawValue, parameters: parameters, onFailure: { error in
            print("DID FAIL REPORT EVENT: \(event.rawValue)")
            print("REPORT ERROR: \(error.localizedDescription)")
        })
        
        print("Reported event: \(event.rawValue), screen: \(screen), item: \(item?.rawValue ?? "nil")")
    }
}
