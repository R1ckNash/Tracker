//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Ilia Liasin on 31/01/2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    
    func didDoneTracker(id: UUID, _ cell: TrackerCollectionViewCell)
    func didCancelTracker(id: UUID)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerCollectionViewCell"
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .natural
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .init(white: 1, alpha: 0.5)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var previewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var pinIconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "pin.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        iv.isHidden = true
        return iv
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(toggleTracker), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Methods
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Private Properties
    
    private var trackerId: UUID?
    private var isCompleted: Bool = false {
        didSet { updateUI() }
    }
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(previewContainerView)
        previewContainerView.addSubview(emojiLabel)
        previewContainerView.addSubview(titleLabel)
        previewContainerView.addSubview(pinIconImageView)
        
        contentView.addSubview(actionButton)
        contentView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            
            previewContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewContainerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: previewContainerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -12),
            
            pinIconImageView.topAnchor.constraint(equalTo: previewContainerView.topAnchor, constant: 18),
            pinIconImageView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -12),
            pinIconImageView.heightAnchor.constraint(equalToConstant: 12),
            pinIconImageView.widthAnchor.constraint(equalToConstant: 12),
            
            actionButton.topAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: 8),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            actionButton.heightAnchor.constraint(equalToConstant: 34),
            actionButton.widthAnchor.constraint(equalToConstant: 34),
            
            countLabel.topAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -54),
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with tracker: Tracker,
                   isCompleted: Bool,
                   completedCount: Int,
                   isFutureDate: Bool) {
        
        self.trackerId = tracker.id
        self.isCompleted = isCompleted
        previewContainerView.backgroundColor = tracker.color
        actionButton.backgroundColor = tracker.color
        titleLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        let format = NSLocalizedString("completedDays", comment: "completed days")
        countLabel.text = String.localizedStringWithFormat(format, completedCount)
        
        actionButton.isEnabled = !isFutureDate
        updateUI()
    }
    
    func updatePinIcon(isPinned: Bool) {
        pinIconImageView.isHidden = !isPinned
    }
    
    func getPreview() -> UIView {
        previewContainerView
    }
    
    // MARK: - Private Methods
    
    @objc private func toggleTracker() {
        guard let id = trackerId else { return }
        
        isCompleted
        ? delegate?.didCancelTracker(id: id)
        : delegate?.didDoneTracker(id: id, self)
    }
    
    private func updateUI() {
        let imageName = isCompleted ? "checkmark" : "plus"
        actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        actionButton.alpha = isCompleted ? 0.5 : 1.0
    }
    
}
