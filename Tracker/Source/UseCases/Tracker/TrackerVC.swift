//
//  TrackerVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 22/01/2025.
//

import UIKit

final class TrackerVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
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
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    // MARK: - Public Properties
    
    var categories: [TrackerCategory] = [
        .init(title: "Home", trackers: [
            .init(id: UUID(), name: "Play tennis", color: .orange, emoji: "🎾", schedule: .init()),
            .init(id: UUID(), name: "Buy a mushroom", color: .green, emoji: "🍄", schedule: .init()),
            .init(id: UUID(), name: "JetBrains", color: .red, emoji: "🧠", schedule: .init()),
        ]),
        .init(title: "Work", trackers: [
            .init(id: UUID(), name: "Grow a tree", color: .purple, emoji: "🌳", schedule: .init()),
            .init(id: UUID(), name: "Call to parents", color: .systemPink, emoji: "👱", schedule: .init()),
        ])
    ]
    var completedTrackers: Set<TrackerRecord> = []
    var currentDate = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        datePickerValueChanged()
    }
    
    // MARK: - Private Methods
    
    @objc private func addButtonTapped() {
        let addTrackerViewController = NewTrackerVC()
        let navController = UINavigationController(rootViewController: addTrackerViewController)
        present(navController, animated: true)
    }
    
    @objc func datePickerValueChanged() {
        let selectedDate = datePicker.date
        currentDate = selectedDate
        filterTrackers()
    }
    
    private func filterTrackers() {
        if categories.isEmpty {
            showMockScreen(true)
        }
        else {
            showMockScreen(false)
        }
    }
    
    private func configureUI() {
        setupNavBar()
        setupSearchController()
        setupCollectionView()
        setupMockScreen()
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Trackers"
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped))
        
        addButton.tintColor = .black

        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupMockScreen() {
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
    
    private func showMockScreen(_ bool: Bool) {
        
        imageLabel.isHidden = !bool
        textLabel.isHidden = !bool
        collectionView.isHidden = bool
    }
    
    private func setupCollectionView() {
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 7) / CGFloat(2)
        return CGSize(width: cellWidth, height: cellWidth * 0.88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
                                                            
                                                            for: indexPath) as? TrackerCollectionViewCell else {
            return TrackerCollectionViewCell()
        }
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        cell.configure(with: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = SupplementaryView.reuseIdentifier
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView
        view.configure(with: categories[indexPath.section].title)
        return view
    }
    
}
