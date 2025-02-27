//
//  StatisticVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 22/01/2025.
//

import UIKit

final class StatisticVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var statisticViewContainer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .label
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "Completed trackers"
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .label
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var nothingAnalyzeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There is nothing to analyze yet"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.isHidden = false
        return label
    }()
    
    private lazy var nothingAnalyzeImage: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.image = UIImage(named: "emptyStatistics")
        label.isHidden = false
        return label
    }()
    
    // MARK: - Private Properties
    
    private lazy var dataProvider: DataProvider = {
        return DIContainer.shared.makeDataProvider()
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        updateStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStatistics()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statisticViewContainer.addGradientBorder()
    }
    
    // MARK: - Private Methods
    
    private func updateStatistics() {
        let count = dataProvider.getTotalCompletedCount()
        
        if count == 0 {
            statisticViewContainer.isHidden = true
            nothingAnalyzeLabel.isHidden = false
            nothingAnalyzeImage.isHidden = false
        } else {
            statisticViewContainer.isHidden = false
            nothingAnalyzeLabel.isHidden = true
            nothingAnalyzeImage.isHidden = true
            countLabel.text = "\(count)"
        }
    }
    
    private func configureUI() {
        
        navigationItem.title = "Statistics"
        view.backgroundColor = .systemBackground
        
        view.addSubview(nothingAnalyzeImage)
        view.addSubview(nothingAnalyzeLabel)
        view.addSubview(statisticViewContainer)
        statisticViewContainer.addSubview(textLabel)
        statisticViewContainer.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            nothingAnalyzeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingAnalyzeImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -323),
            
            nothingAnalyzeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingAnalyzeLabel.topAnchor.constraint(equalTo: nothingAnalyzeImage.bottomAnchor, constant: 8),
            
            statisticViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            statisticViewContainer.heightAnchor.constraint(equalToConstant: 90),
            
            countLabel.leadingAnchor.constraint(equalTo: statisticViewContainer.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: statisticViewContainer.topAnchor, constant: 12),
            
            textLabel.leadingAnchor.constraint(equalTo: statisticViewContainer.leadingAnchor, constant: 7),
            textLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 12),
        ])
    }
    
}
