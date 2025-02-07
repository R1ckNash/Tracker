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
    
    // MARK: - Public Properties
    
    var newTrackerType: TrackerType?
    weak var delegate: NewTrackerDelegate?
    
    // MARK: - Private Properties
    
    private let defaultCategory = "defaultCategory"
    private var chosenCategory: String = ""
    private var tableOptions = [(title: "Category", subtitle: nil as String?),
                                (title: "Schedule", subtitle: nil as String?)]
    private var chosenTitle: String = "default"
    private var chosenColor: UIColor = .systemPink
    private var chosenEmoji: String = "😄"
    private var chosenSchedule: [WeekDay]?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                                  chosenSchedule: [WeekDay]?) {
        
        let schedule: [String]? = chosenSchedule?.isEmpty ?? true ? nil : chosenSchedule?.map { $0.fullName }
        
        let newTracker = Tracker(
            id: UUID(),
            name: chosenTitle,
            color: chosenColor,
            emoji: chosenEmoji,
            schedule: schedule
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
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleTextField)
        view.addSubview(tableView)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableOptions.count)),
            
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
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
