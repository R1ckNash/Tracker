//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Ilia Liasin on 07/02/2025.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorCollectionViewCell"
    
    // MARK: - UI Elements
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var wrapperView: UIView = {
        let wrapperView = UIView()
        wrapperView.layer.cornerRadius = 8
        wrapperView.layer.borderWidth = 0
        wrapperView.layer.borderColor = nil
        return wrapperView
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
        
        contentView.addSubview(colorView)
        contentView.addSubview(wrapperView)
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            wrapperView.heightAnchor.constraint(equalToConstant: 46),
            wrapperView.widthAnchor.constraint(equalToConstant: 46),
            wrapperView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            wrapperView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func getColor() -> UIColor {
        colorView.backgroundColor ?? .white
    }
}
