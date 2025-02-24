//
//  CategoryCell.swift
//  Tracker
//
//  Created by Ilia Liasin on 24/02/2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Public Properties

    static let identifier = "CategoryCell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .black
        
        detailTextLabel?.font = .systemFont(ofSize: 17)
        detailTextLabel?.textColor = .gray
        
        selectionStyle = .none
        
        contentView.addSubview(checkmarkImageView)
        
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with text: String, isSelected: Bool) {
        textLabel?.text = text
        checkmarkImageView.isHidden = !isSelected
    }
}
