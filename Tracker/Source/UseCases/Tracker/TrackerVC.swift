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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        label.text = "mock.title".localized
        label.textColor = .black
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    // MARK: - Private Properties
    
    private var currentDate = Date()
    
    private lazy var dataProvider: DataProvider = {
        return DIContainer.shared.makeDataProvider()
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        currentDate = Calendar.current.startOfDay(for: selectedDate)
        filterTrackers()
    }
    
    private func filterTrackers() {
        let calendar = Calendar.current
        let weekdayIndex = (calendar.component(.weekday, from: currentDate) + 5) % 7
        let selectedWeekday = WeekDay(rawValue: weekdayIndex)
        
        dataProvider.performFetchByDay(for: selectedWeekday?.fullName ?? "")
        
        showMockScreen(dataProvider.getNumberOfSections() == 0)
        collectionView.reloadData()
    }
    
    private func isTrackerCompleted(id: UUID) -> Bool {
        let result = dataProvider.isRecordExist(for: id, on: currentDate)
        return result
    }
    
    private func configureUI() {
        setupNavBar()
        setupSearchController()
        setupCollectionView()
        setupMockScreen()
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "trackerVC.navTitle".localized
        
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
        searchController.searchBar.placeholder = "search.placeholder".localized
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
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
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = "\(indexPath.section)-\(indexPath.row)" as NSString
        let tracker = dataProvider.getTracker(at: indexPath)
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu() }
            let pinAction = self.createPinAction(for: tracker)
            let editAction = self.createEditAction(for: tracker)
            let deleteAction = self.createDeleteAction(for: tracker)
            return UIMenu(children: [pinAction, editAction, deleteAction])
        }
    }
    
    private func createPinAction(for tracker: Tracker) -> UIAction {
        let isPinned = dataProvider.isTrackerPinned(for: tracker.id)
        let title = isPinned ? "Unpin" : "Pin"
        return UIAction(title: title) { [weak self] _ in
            guard let self = self else { return }
            if isPinned {
                self.dataProvider.unpinTracker(with: tracker.id)
            } else {
                self.dataProvider.pinTracker(with: tracker.id)
            }
            
            self.filterTrackers()
            self.collectionView.reloadData()
        }
    }
    
    private func createEditAction(for tracker: Tracker) -> UIAction {
        return UIAction(title: "Edit") { [weak self] _ in
            guard let self = self else { return }
            let editVC = EditTrackerVC()
            
            if tracker.schedule.isEmpty {
                editVC.trackerType = .event
            } else {
                editVC.trackerType = .habit
            }
            editVC.delegate = self
            editVC.tracker = tracker
            editVC.completedCount = dataProvider.getCompleteDaysCount(for: tracker.id)
            editVC.categoryName = dataProvider.getTrackerCategoryName(by: tracker.id)
            let navController = UINavigationController(rootViewController: editVC)
            self.present(navController, animated: true)
        }
    }
    
    private func createDeleteAction(for tracker: Tracker) -> UIAction {
        return UIAction(title: "Delete", attributes: .destructive) { [weak self] _ in
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let identifier = configuration.identifier as? String else { return nil }
        
        let components = identifier.split(separator: "-")
        guard components.count == 2,
              let section = Int(components[0]),
              let row = Int(components[1])
        else {
            return nil
        }
        let indexPath = IndexPath(row: row, section: section)
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        return UITargetedPreview(view: cell.getPreview())
    }
    
}

// MARK: - UICollectionViewDataSource

extension TrackerVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataProvider.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataProvider.getNumberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return TrackerCollectionViewCell()
        }
        
        let tracker = dataProvider.getTracker(at: indexPath)
        let isCompleted = isTrackerCompleted(id: tracker.id)
        let completedCount = dataProvider.getCompleteDaysCount(for: tracker.id)
        let isFutureDate = currentDate > Date()
        
        let pinned = dataProvider.isTrackerPinned(for: tracker.id)
        cell.updatePinIcon(isPinned: pinned)
        
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
        
        view.configure(with: dataProvider.category(for: indexPath.section) ?? "")
        return view
    }
}

// MARK: - NewTrackerDelegate

extension TrackerVC: NewTrackerDelegate {
    
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory) {
        
        let tracker = newTrackerCategory.trackers[0]
        if dataProvider.trackerExists(with: tracker.id) {
            updateExistingTracker(tracker)
        } else {
            createNewTracker(tracker, in: newTrackerCategory.title)
        }
        filterTrackers()
    }
    
    private func updateExistingTracker(_ tracker: Tracker) {
        dataProvider.updateTracker(tracker)
    }
    
    private func createNewTracker(_ tracker: Tracker, in categoryTitle: String) {
        if dataProvider.getTrackerCategory(by: categoryTitle) != nil {
            dataProvider.updateTrackerCategory(title: categoryTitle, newTracker: tracker)
        } else {
            dataProvider.createTrackerCategory(categoryTitle: categoryTitle)
            dataProvider.updateTrackerCategory(title: categoryTitle, newTracker: tracker)
        }
    }
}

// MARK: - TrackerCellDelegate

extension TrackerVC: TrackerCellDelegate {
    
    func didDoneTracker(id: UUID, _ cell: TrackerCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = dataProvider.getTracker(at: indexPath)
        
        dataProvider.createRecord(with: id, for: currentDate)
        if tracker.schedule.isEmpty {
            dataProvider.deleteTracker(by: id)
        }
        
        filterTrackers()
    }
    
    func didCancelTracker(id: UUID) {
        
        dataProvider.deleteRecord(with: id, for: currentDate)
        collectionView.reloadData()
    }
    
}

// MARK: - UISearchResultsUpdating

extension TrackerVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        dataProvider.filterCategories(with: searchText)
        collectionView.reloadData()
    }
}
