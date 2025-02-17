//
//  NewTrackerDetailsVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 04/02/2025.
//

import UIKit

final class NewTrackerDetailsVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.layer.cornerRadius = 16
        textField.placeholder = "Enter tracker name"
        textField.backgroundColor = .init(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        textField.font = .systemFont(ofSize: 17)
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.rightView = clearSearchButton
        textField.leftView = .init(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        return textField
    }()
    
    private lazy var clearSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "specsCellTitle")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "specsCellSubtitle")
        table.layer.cornerRadius = 16
        table.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        return table
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .init(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00).cgColor
        button.setTitleColor(.init(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var emojiCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(EmojiCollectionViewCell.self,
                            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        collection.register(NewTrackerHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier)
        collection.delegate = self
        collection.dataSource = self
        collection.tag = 1
        return collection
    }()
    
    private lazy var colorCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(ColorCollectionViewCell.self,
                            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        collection.register(NewTrackerHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier)
        collection.delegate = self
        collection.dataSource = self
        collection.tag = 2
        return collection
    }()
    
    // MARK: - Public Properties
    
    var newTrackerType: TrackerType?
    weak var delegate: NewTrackerDelegate?
    
    // MARK: - Private Properties
    
    private let defaultCategory = "defaultCategory"
    private var chosenCategory: String = ""
    private var tableOptions = [(title: "Category", subtitle: nil as String?),
                                (title: "Schedule", subtitle: nil as String?)]
    private var previousChosenEmojiCell: EmojiCollectionViewCell?
    private var previousChosenColorCell: ColorCollectionViewCell?
    private var chosenTitle: String = "default"
    private var chosenColor: UIColor = .systemPink
    private var chosenEmoji: String = "😄"
    private var chosenSchedule: [WeekDay]?
    private let headerList = ["Emoji", "Color"]
    private let emojiList = [
        "🙂", "😻", "🌺", "🐶", "❤", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪",]
    private let colorList: [UIColor] = [
        .init(red: 0.99, green: 0.30, blue: 0.29, alpha: 1.00),
        .init(red: 1.00, green: 0.53, blue: 0.12, alpha: 1.00),
        .init(red: 0.00, green: 0.48, blue: 0.98, alpha: 1.00),
        .init(red: 0.43, green: 0.27, blue: 1.00, alpha: 1.00),
        .init(red: 0.20, green: 0.81, blue: 0.41, alpha: 1.00),
        .init(red: 0.90, green: 0.43, blue: 0.83, alpha: 1.00),
        .init(red: 0.98, green: 0.83, blue: 0.83, alpha: 1.00),
        .init(red: 0.20, green: 0.65, blue: 1.00, alpha: 1.00),
        .init(red: 0.27, green: 0.90, blue: 0.62, alpha: 1.00),
        .init(red: 0.21, green: 0.20, blue: 0.49, alpha: 1.00),
        .init(red: 1.00, green: 0.40, blue: 0.30, alpha: 1.00),
        .init(red: 1.00, green: 0.60, blue: 0.80, alpha: 1.00),
        .init(red: 0.96, green: 0.77, blue: 0.55, alpha: 1.00),
        .init(red: 0.47, green: 0.58, blue: 0.96, alpha: 1.00),
        .init(red: 0.51, green: 0.17, blue: 0.95, alpha: 1.00),
        .init(red: 0.68, green: 0.34, blue: 0.85, alpha: 1.00),
        .init(red: 0.55, green: 0.45, blue: 0.90, alpha: 1.00),
        .init(red: 0.18, green: 0.82, blue: 0.35, alpha: 1.00)]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDismissKeyboardGesture()
        setupDefaultData()
        configureUI()
    }
    
    // MARK: - Private Methods
    
    @objc private func createButtonPressed() {
        
        let schedule = chosenSchedule ?? []
        createNewTracker(chosenCategory: chosenCategory,
                         chosenTitle: chosenTitle,
                         chosenColor: chosenColor,
                         chosenEmoji: chosenEmoji,
                         chosenSchedule: schedule)
    }
    
    private func createNewTracker(chosenCategory: String,
                                  chosenTitle: String,
                                  chosenColor: UIColor,
                                  chosenEmoji: String,
                                  chosenSchedule: [WeekDay]) {
        
        let newTracker = Tracker(
            id: UUID(),
            name: chosenTitle,
            color: chosenColor,
            emoji: chosenEmoji,
            schedule: chosenSchedule.map { $0.fullName }
        )
        
        let newTrackerCategory = TrackerCategory(
            title: chosenCategory,
            trackers: [newTracker]
        )
        
        delegate?.didReceiveNewTracker(newTrackerCategory: newTrackerCategory)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange() {
        chosenTitle = titleTextField.text ?? ""
        updateCreateButtonState()
    }
    
    @objc private func clearTextField() {
        titleTextField.text = ""
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateCreateButtonState() {
        let isFormValid = !(chosenTitle.isEmpty)
        createButton.isEnabled = isFormValid
        createButton.backgroundColor = isFormValid ? .black : .gray
    }
    
    private func setupDefaultData() {
        tableOptions = newTrackerType == .habit
        ? [(title: "Category", subtitle: defaultCategory),
           (title: "Schedule", subtitle: nil as String?)]
        : [(title: "Category", subtitle: defaultCategory)]
        chosenCategory = defaultCategory
    }
    
    private func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.title = newTrackerType == .habit ? "New habit" : "New event"
        navigationItem.hidesBackButton = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(tableView)
        contentView.addSubview(emojiCollection)
        contentView.addSubview(colorCollection)
        contentView.addSubview(createButton)
        contentView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableOptions.count)),
            
            emojiCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            emojiCollection.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiCollection.heightAnchor.constraint(equalToConstant: 204 + 18),
            
            colorCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 16),
            colorCollection.heightAnchor.constraint(equalToConstant: 204 + 18),
            
            createButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            cancelButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
        
    }
}

extension NewTrackerDetailsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        switch selectedCell?.textLabel?.text {
        case "Category":
            chosenCategory = defaultCategory
            tableOptions[0].subtitle = chosenCategory
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
            
        case "Schedule":
            let nextScreen = ScheduleVC()
            nextScreen.delegate = self
            nextScreen.scheduleSelection = chosenSchedule ?? []
            navigationController?.pushViewController(nextScreen, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

extension NewTrackerDetailsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableOptions[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.detailTextLabel?.textColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        return cell
    }
    
}

// MARK: - ScheduleSelectionDelegate

extension NewTrackerDetailsVC: ScheduleSelectionDelegate {
    
    func didSelectSchedule(_ schedule: [WeekDay]) {
        chosenSchedule = schedule
        let scheduleText = schedule.isEmpty ? nil : schedule.map { $0.shortName }.joined(separator: ", ")
        tableOptions[1].subtitle = scheduleText
        tableView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewTrackerDetailsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell {
                if let previousChosenEmojiCell {
                    previousChosenEmojiCell.backgroundColor = nil
                }
                chosenEmoji = cell.getEmoji()
                cell.backgroundColor = .init(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.00)
                cell.layer.cornerRadius = 16
                previousChosenEmojiCell = cell
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                if let previousChosenColorCell {
                    previousChosenColorCell.layer.borderColor = nil
                    previousChosenColorCell.layer.borderWidth = 0
                }
                chosenColor = cell.getColor()
                cell.layer.borderColor = chosenColor.withAlphaComponent(0.3).cgColor
                cell.layer.borderWidth = 3
                cell.layer.cornerRadius = 8
                previousChosenColorCell = cell
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension NewTrackerDetailsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.tag == 1 ? emojiList.count : colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier, for: indexPath) as? EmojiCollectionViewCell
            
            cell?.configure(with: emojiList[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell
            
            cell?.configure(with: colorList[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier,
            for: indexPath) as? NewTrackerHeaderView
        
        header?.labelText = headerList[collectionView.tag - 1]
        return header ?? UICollectionReusableView()
    }
    
}
