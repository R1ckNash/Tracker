//
//  NewCategoryVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 23/02/2025.
//

import UIKit

protocol NewCategoryDelegate: AnyObject {
    func addNewCategory(newCategory: String)
}

final class NewCategoryVC: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.text = "New category"
        return label
    }()
    
    private lazy var categoryName: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray.withAlphaComponent(0.3)
        textField.tintColor = .black
        textField.textColor =  .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Enter name of category"
        textField.leftView = .init(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.titleLabel?.textColor = .white
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: NewCategoryDelegate?
    
    // MARK: - Private Properties
    
    private var previousText: String?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        configureUI()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.titleView = titleLabel
    }
    
    private func validateCategoryButton() {
        let isCategoryNameFilled = !(categoryName.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        categoryButton.isEnabled = isCategoryNameFilled
        categoryButton.backgroundColor = categoryButton.isEnabled ? .black : .gray
    }
    
    @objc private func categoryButtonTapped() {
        guard let categoryName = categoryName.text?.trimmingCharacters(in: .whitespaces),
              !categoryName.isEmpty else { return }
        
        delegate?.addNewCategory(newCategory: categoryName)
        dismiss(animated: true, completion: nil)
    }
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(categoryName)
        view.addSubview(categoryButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            categoryName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            
            categoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text != previousText else { return }
        previousText = text
        validateCategoryButton()
    }
}
