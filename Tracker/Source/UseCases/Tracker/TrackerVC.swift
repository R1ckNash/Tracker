//
//  TrackerVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 22/01/2025.
//

import UIKit

protocol NewTrackerDelegate: AnyObject {
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory)
}

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
    
    // MARK: - Private Properties
    private var filteredCategories: [TrackerCategory] = []
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date()
    private var dataProvider: DataProvider!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider = DIContainer.shared.makeDataProvider(trackerCollection: collectionView)
        
        configureUI()
        datePickerValueChanged()
    }
    
    // MARK: - Private Methods
    
    @objc private func addButtonTapped() {
        let addTrackerViewController = NewTrackerVC()
        addTrackerViewController.delegate = self
        let navController = UINavigationController(rootViewController: addTrackerViewController)
        present(navController, animated: true)
    }
    
    @objc func datePickerValueChanged() {
        let selectedDate = datePicker.date
        currentDate = selectedDate
        filterTrackers()
    }
    
    private func removeTrackerFromCategories(_ tracker: Tracker) {
        categories = categories.map { category in
            let updatedTrackers = category.trackers.filter { $0.id != tracker.id }
            return TrackerCategory(title: category.title, trackers: updatedTrackers)
        }
    }
    
    private func filterTrackers() {
        let calendar = Calendar.current
        let weekdayIndex = (calendar.component(.weekday, from: currentDate) + 5) % 7
        let selectedWeekday = WeekDay(rawValue: weekdayIndex)
        
        filteredCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                
                guard let schedule = tracker.schedule else {
                    return !completedTrackers.contains(where: { $0.id == tracker.id })
                }
                
                return selectedWeekday.map { schedule.contains($0.fullName) } ?? false
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        showMockScreen(filteredCategories.isEmpty)
        collectionView.reloadData()
    }
    
    private func getTrackerCategory(by title: String) -> TrackerCategory? {
        return categories.first { $0.title == title }
    }
    
    private func updateTrackerCategory(title: String, newTracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.title == title }) {
            let updatedCategory = TrackerCategory(
                title: categories[index].title,
                trackers: categories[index].trackers + [newTracker]
            )
            categories[index] = updatedCategory
        }
        collectionView.reloadData()
    }
    
    private func createTrackerCategory(categoryTitle: String) {
        let newCategory = TrackerCategory(title: categoryTitle, trackers: [])
        categories.append(newCategory)
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
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
        filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return TrackerCollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
        let isCompleted = completedTrackers.contains(trackerRecord)
        let completedCount = completedTrackers.filter { $0.id == tracker.id }.count
        let isFutureDate = currentDate > Date()
        
        cell.configure(with: tracker, isCompleted: isCompleted, completedCount: completedCount, isFutureDate: isFutureDate)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SupplementaryView.reuseIdentifier,
            for: indexPath
        ) as? SupplementaryView
        
        guard let view = view else {
            return UICollectionReusableView()
        }
        
        view.configure(with: filteredCategories[indexPath.section].title)
        return view
    }
}

// MARK: - NewTrackerDelegate

extension TrackerVC: NewTrackerDelegate {
    
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory) {
        if getTrackerCategory(by: newTrackerCategory.title) != nil {
            updateTrackerCategory(title: newTrackerCategory.title, newTracker: newTrackerCategory.trackers[0])
        } else {
            createTrackerCategory(categoryTitle: newTrackerCategory.title)
            updateTrackerCategory(title: newTrackerCategory.title, newTracker: newTrackerCategory.trackers[0])
        }
        filterTrackers()
    }
}

extension TrackerVC: TrackerCellDelegate {
    
    func didToggleTracker(_ cell: TrackerCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
        
        if completedTrackers.contains(trackerRecord) {
            completedTrackers.remove(trackerRecord)
        } else if currentDate <= Date() {
            completedTrackers.insert(trackerRecord)
        }
        filterTrackers()
    }
}
