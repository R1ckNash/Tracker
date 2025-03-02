//
//  EditTrackerVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 26/02/2025.
//

import UIKit

final class EditTrackerVC: BaseTrackerDetailsVC {
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var tracker: Tracker?
    var completedCount: Int?
    var categoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit tracker"
        populateData()
    }
    
    private func populateData() {
        
        guard
            let tracker,
            let completedCount = completedCount,
            let categoryName = categoryName
        else {
            assertionFailure("Data can't be populated")
            return
        }
        
        setTitleText(tracker.name)
        chosenTitle = tracker.name
        chosenEmoji = tracker.emoji
        chosenColor = tracker.color
        setCreateButtonTitle("Update")
        
        tableOptions[0].subtitle = categoryName
        
        let format = NSLocalizedString("completedDays", comment: "Completed days")
        daysLabel.text = String.localizedStringWithFormat(format, completedCount)
        
        if !tracker.schedule.isEmpty {
            
            let shortNames = tracker.schedule.compactMap { fullName -> String? in
                if let day = WeekDay.allCases.first(where: { $0.fullName.lowercased() == fullName.lowercased() }) {
                    return day.shortName
                }
                return nil
            }
            let scheduleText = shortNames.joined(separator: ", ")
            tableOptions[1].subtitle = scheduleText
        }
        
        highlightCells()
        updateCreateButtonState()
    }
    
    private func highlightCells() {
        
        emojiCollection.layoutIfNeeded()
        colorCollection.layoutIfNeeded()
        
        if let emojiIndex = emojiList.firstIndex(where: { $0 == chosenEmoji }) {
            let indexPath = IndexPath(item: emojiIndex, section: 0)
            if let cell = emojiCollection.cellForItem(at: indexPath) as? EmojiCollectionViewCell {
                cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.00)
                cell.layer.cornerRadius = 16
                previousChosenEmojiCell = cell
            }
        }
        
        if let colorIndex = colorList.firstIndex(where: { $0 == chosenColor }) {
            let indexPath = IndexPath(item: colorIndex, section: 0)
            if let cell = colorCollection.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                cell.layer.borderColor = chosenColor.withAlphaComponent(0.3).cgColor
                cell.layer.borderWidth = 3
                cell.layer.cornerRadius = 8
                previousChosenColorCell = cell
            }
        }
    }
    
    // MARK: - Public Methods
    
    override func configureUI() {
        super.configureUI()
        
        contentView.addSubview(daysLabel)
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            daysLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        titleTextFieldTopConstraint.isActive = false
        titleTextFieldTopConstraint = titleTextField.topAnchor.constraint(
            equalTo: daysLabel.bottomAnchor, constant: 40)
        titleTextFieldTopConstraint.isActive = true
    }
    
    override func createButtonPressed() {
        guard let tracker, let title = titleTextField.text else { return }
        
        let schedule = chosenSchedule ?? []
        let updatedTracker = Tracker(
            id: tracker.id,
            name: title,
            color: chosenColor,
            emoji: chosenEmoji,
            schedule: schedule.map { $0.fullName }
        )
        let newTrackerCategory = TrackerCategory(title: chosenCategory, trackers: [updatedTracker])
        delegate?.didReceiveNewTracker(newTrackerCategory: newTrackerCategory)
        dismiss(animated: true, completion: nil)
    }
}
