//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Ilia Liasin on 22/01/2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var imageLabel: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.image = UIImage(named: "Mock")
        
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What are we going to track?"
        label.textColor = .black
        
        return label
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        setupNavBar()
        setupBackground()
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Trackers"
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped))
        
        addButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        print("Add button tapped")
    }
    
    private func setupBackground() {
        view.addSubview(imageLabel)
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageLabel.widthAnchor.constraint(equalToConstant: 80),
            imageLabel.heightAnchor.constraint(equalToConstant: 80),
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 8)
        ])
    }

}
