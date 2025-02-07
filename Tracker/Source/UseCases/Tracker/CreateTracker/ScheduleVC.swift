//
//  ScheduleVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 05/02/2025.
//

import UIKit

enum WeekDay: Int, CaseIterable {
    
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var fullName: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return "Mo"
        case .tuesday: return "Tu"
        case .wednesday: return "We"
        case .thursday: return "Th"
        case .friday: return "Fr"
        case .saturday: return "Sa"
        case .sunday: return "Su"
        }
    }
}

protocol ScheduleSelectionDelegate: AnyObject {
    func didSelectSchedule(_ schedule: [WeekDay])
}

final class ScheduleVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var scheduleTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "scheduleCell")
        table.layer.cornerRadius = 16
        table.backgroundColor = .init(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var doneScheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.layer.cornerRadius = 16
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneScheduleButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: ScheduleSelectionDelegate?
    var scheduleSelection: [WeekDay] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Private Methods
    
    @objc private func doneScheduleButtonPressed() {
        delegate?.didSelectSchedule(scheduleSelection)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        let selectedDay = WeekDay.allCases[sender.tag]
        
        if sender.isOn {
            scheduleSelection.append(selectedDay)
        } else {
            scheduleSelection.removeAll { $0 == selectedDay }
        }
        
        scheduleSelection.isEmpty ? disableDoneButton() : enableDoneButton()
    }
    
    private func enableDoneButton() {
        doneScheduleButton.isEnabled = true
        doneScheduleButton.backgroundColor = .init(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    }
    
    private func disableDoneButton() {
        doneScheduleButton.isEnabled = false
        doneScheduleButton.backgroundColor = .init(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
    }
    
    private func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.title = "Schedule"
        navigationItem.hidesBackButton = true
        scheduleSelection.count > 0 ? enableDoneButton() : disableDoneButton()
        
        view.addSubview(scheduleTableView)
        view.addSubview(doneScheduleButton)
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        doneScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneScheduleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneScheduleButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }
    
}

// MARK: - UITableViewDelegate

extension ScheduleVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

// MARK: - UITableViewDataSource

extension ScheduleVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        let currentDay = WeekDay.allCases[indexPath.row]
        cell.textLabel?.text = currentDay.fullName
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        
        let switchControl = UISwitch()
        switchControl.isOn = scheduleSelection.contains(currentDay)
        switchControl.onTintColor = UIColor(red: 0.22, green: 0.45, blue: 0.91, alpha: 1.00)
        switchControl.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        switchControl.tag = indexPath.row
        
        cell.accessoryView = switchControl
        return cell
    }
    
}
