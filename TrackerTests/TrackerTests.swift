//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Ilia Liasin on 27/02/2025.
//


import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testTrackerVC() throws {
        
        let trackerVC = TrackerVC()
        assertSnapshot(of: trackerVC, as: .image)
    }
    
}
