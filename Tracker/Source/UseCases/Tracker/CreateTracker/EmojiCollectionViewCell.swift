//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Ilia Liasin on 07/02/2025.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojiCollectionViewCell"
    
    // MARK: - UI Elements
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .medium)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        
        contentView.addSubview(emojiLabel)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    func getEmoji() -> String {
        emojiLabel.text ?? ""
    }
}
