//
//  NewTrackerVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 04/02/2025.
//

import UIKit

enum TrackerType {
    case habit
    case event
}

final class NewTrackerVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Habit", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Event", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(eventButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    weak var delegate: NewTrackerDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Private Methods
    
    @objc private func habitButtonPressed() {
        let trackerDetailsVC = NewTrackerDetailsVC()
        trackerDetailsVC.trackerType = .habit
        trackerDetailsVC.delegate = delegate
        navigationController?.pushViewController(trackerDetailsVC, animated: true)
    }
    
    @objc private func eventButtonPressed() {
        let trackerDetailsVC = NewTrackerDetailsVC()
        trackerDetailsVC.trackerType = .event
        trackerDetailsVC.delegate = delegate
        navigationController?.pushViewController(trackerDetailsVC, animated: true)
    }
    
    private func configureUI() {
        
        navigationItem.title = "Creating a tracker"
        view.backgroundColor = .white
        
        view.addSubview(habitButton)
        view.addSubview(eventButton)
        
        NSLayoutConstraint.activate([
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 8),
        ])
    }
    
}
