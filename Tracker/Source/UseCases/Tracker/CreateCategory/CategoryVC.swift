//
//  CategoryVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 23/02/2025.
//

import UIKit

protocol CategoryVCDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

final class CategoryVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var placeholderImage: UIImageView = {
        let errorImage = UIImageView()
        errorImage.image = UIImage(named: "Mock")
        return errorImage
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Habits and events can be combined by meaning"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
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
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.setTitle("Add category", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: CategoryVCDelegate?
    
    // MARK: - Private Properties
    
    private var categoryViewModel: CategoryViewModel
    
    // MARK: - Initializers
    
    init(categoryViewModel: CategoryViewModel) {
        self.categoryViewModel = categoryViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMockScreen()
        configureUI()
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        
        categoryViewModel.onCategoriesUpdated = { [weak self] categories in
            self?.tableView.reloadData()
            self?.updateTableViewHeight()
            self?.showMockScreen()
        }
    }
    
    private func updateTableViewHeight() {
        let categoriesCount = categoryViewModel.getCategories().count
        let newHeight = CGFloat(75 * categoriesCount)
        
        if let existingConstraint = tableView.constraints.first(where: { $0.firstAttribute == .height }) {
            existingConstraint.isActive = false
        }
        
        tableView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
    }
    
    private func showMockScreen() {
        
        let areCategoriesEmpty = categoryViewModel.getCategories().isEmpty
        
        placeholderImage.isHidden = !areCategoriesEmpty
        placeholderLabel.isHidden = !areCategoriesEmpty
        tableView.isHidden = areCategoriesEmpty
    }
    
    private func configureUI() {
        
        navigationItem.title = "Category"
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(categoryButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant:
                                                CGFloat(75 * categoryViewModel.getCategoriesCount())),
            
            categoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupMockScreen() {
        
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc private func categoryButtonTapped() {
        let newCategoryVC = NewCategoryVC()
        newCategoryVC.delegate = self
        let navigationController = UINavigationController(rootViewController: newCategoryVC)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true)
    }
    
}

// MARK: - UITableViewDelegate

extension CategoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryName = categoryViewModel.getCategories()[indexPath.row]
        categoryViewModel.selectCategory(categoryName)
        delegate?.didSelectCategory(categoryName)
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension CategoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = categoryViewModel.getCategories().count
        showMockScreen()
        return count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        if indexPath.row == categoryViewModel.getCategories().count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.identifier,
            for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        let categoryName = categoryViewModel.getCategories()[indexPath.row]
        let isSelected = categoryViewModel.isCategorySelected(categoryName)
        cell.configure(with: categoryName, isSelected: isSelected)
        return cell
    }
}

// MARK: - NewCategoryDelegate

extension  CategoryVC: NewCategoryDelegate {
    
    func addNewCategory(newCategory: String) {
        categoryViewModel.addCategory(newCategory)
        categoryViewModel.loadCategories()
        updateTableViewHeight()
        tableView.reloadData()
        showMockScreen()
    }
}
