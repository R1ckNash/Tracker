//
//  BaseTrackerDetailsVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 26/02/2025.
//

import UIKit

class BaseTrackerDetailsVC: UIViewController {
    
    // MARK: - UI Elements
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .init(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var emojiCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var colorCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
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
    
    var trackerType: TrackerType?
    weak var delegate: NewTrackerDelegate?
    
    var titleTextFieldTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    var chosenCategory: String = ""
    var tableOptions = [(title: "Category", subtitle: nil as String?),
                        (title: "Schedule", subtitle: nil as String?)]
    var previousChosenEmojiCell: EmojiCollectionViewCell?
    var previousChosenColorCell: ColorCollectionViewCell?
    var chosenTitle: String = "default"
    var chosenColor: UIColor = .systemPink
    var chosenEmoji: String = "😄"
    var chosenSchedule: [WeekDay]?
    private let headerList = ["Emoji", "Color"]
    let emojiList = [
        "🙂", "😻", "🌺", "🐶", "❤", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪",]
    let colorList: [UIColor] = [
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
        
        configureKeyboard()
        setupDefaultData()
        configureUI()
    }
    
    // MARK: - Private Methods
    
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
    
    private func configureKeyboard() {
        hideKeyboardWhenTappedAround()
    }
    
    private func setupDefaultData() {
        tableOptions = trackerType == .habit
        ? [(title: "Category", subtitle: nil),
           (title: "Schedule", subtitle: nil)]
        : [(title: "Category", subtitle: nil)]
        
        chosenCategory = ""
    }
    
    // MARK: - Public Methods
    
    @objc func createButtonPressed() {}
    
    func updateCreateButtonState() {
        let isFormValid = !chosenTitle.isEmpty
        createButton.isEnabled = isFormValid
        createButton.backgroundColor = isFormValid ? .black : .gray
    }
    
    func setTitleText(_ text: String) {
        titleTextField.text = text
    }
    
    func setCreateButtonTitle(_ title: String) {
        createButton.setTitle(title, for: .normal)
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        navigationItem.titleView?.tintColor = .label
        navigationItem.hidesBackButton = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(tableView)
        contentView.addSubview(emojiCollection)
        contentView.addSubview(colorCollection)
        contentView.addSubview(createButton)
        contentView.addSubview(cancelButton)
        
        titleTextFieldTopConstraint = titleTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24)
        
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
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            titleTextFieldTopConstraint,
            
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

extension BaseTrackerDetailsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        switch selectedCell?.textLabel?.text {
        case "Category":
            
            let categoryViewModel = DIContainer.shared.makeCategoryViewModel()
            let categoryVC = CategoryVC(categoryViewModel: categoryViewModel)
            categoryVC.delegate = self
            navigationController?.pushViewController(categoryVC, animated: true)
            
        case "Schedule":
            
            let scheduleVC = DIContainer.shared.makeScheduleVC()
            scheduleVC.delegate = self
            scheduleVC.scheduleSelection = chosenSchedule ?? []
            navigationController?.pushViewController(scheduleVC, animated: true)
            
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

extension BaseTrackerDetailsVC: UITableViewDataSource {
    
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

// MARK: - CategoryVCDelegate

extension BaseTrackerDetailsVC: CategoryVCDelegate {
    
    func didSelectCategory(_ category: String) {
        chosenCategory = category
        tableOptions[0].subtitle = chosenCategory
        tableView.reloadData()
    }
}

// MARK: - ScheduleSelectionDelegate

extension BaseTrackerDetailsVC: ScheduleSelectionDelegate {
    
    func didSelectSchedule(_ schedule: [WeekDay]) {
        chosenSchedule = schedule
        let scheduleText = schedule.isEmpty ? nil : schedule.map { $0.shortName }.joined(separator: ", ")
        tableOptions[1].subtitle = scheduleText
        tableView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BaseTrackerDetailsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 18)
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

extension BaseTrackerDetailsVC: UICollectionViewDataSource {
    
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

