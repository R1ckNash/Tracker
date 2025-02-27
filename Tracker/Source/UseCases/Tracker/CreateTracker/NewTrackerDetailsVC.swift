//
//  NewTrackerDetailsVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 04/02/2025.
//

import UIKit

final class NewTrackerDetailsVC: BaseTrackerDetailsVC {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = trackerType == .habit ? "New habit" : "New event"
    }
    
    // MARK: - Public Methods
    
    override func createButtonPressed() {
        let schedule = chosenSchedule ?? []
        let newTracker = Tracker(
            id: UUID(),
            name: chosenTitle,
            color: chosenColor,
            emoji: chosenEmoji,
            schedule: schedule.map { $0.fullName }
        )
        let newTrackerCategory = TrackerCategory(title: chosenCategory, trackers: [newTracker])
        delegate?.didReceiveNewTracker(newTrackerCategory: newTrackerCategory)
        dismiss(animated: true, completion: nil)
    }
}
