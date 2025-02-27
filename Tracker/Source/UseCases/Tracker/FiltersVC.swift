//
//  FiltersVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 26/02/2025.
//

import UIKit

final class FiltersVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identifier)
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [
            .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner
        ]
        tableView.clipsToBounds = true
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Public Properties
    
    var onFilterSelected: ((Int) -> Void)?
    var selectedIndex: Int = 0
    var tableOptions = [
        "All trackers",
        "Trackers for today",
        "Completed",
        "Not completed yet"
    ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        
        navigationItem.title = "Filters"
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableOptions.count)),
        ])
    }
    
}

// MARK: - UITableViewDataSource

extension FiltersVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterCell.identifier,
            for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        let filterName = tableOptions[indexPath.row]
        let isSelected = (indexPath.row == selectedIndex)
        cell.configure(with: filterName, isSelected: isSelected)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FiltersVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        tableView.reloadData()
        
        onFilterSelected?(selectedIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
