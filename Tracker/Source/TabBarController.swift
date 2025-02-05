//
//  TabBarController.swift
//  Tracker
//
//  Created by Ilia Liasin on 15/01/2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBar()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBar() {
        
        let border = CALayer()
                border.backgroundColor = UIColor(red: 0.70, green: 0.70, blue: 0.70, alpha: 1.00).cgColor
                border.frame = CGRect(x: 0, y: 0, width: self.tabBar.bounds.width, height: 1.0)
                self.tabBar.layer.addSublayer(border)
        
        let trackerVC = TrackerVC()
        let trackerNC = UINavigationController(rootViewController: trackerVC)
        trackerNC.navigationBar.prefersLargeTitles = true
        trackerVC.tabBarItem = UITabBarItem(title: "Trackers",
                                            image: .init(systemName: "record.circle.fill"),
                                            selectedImage: nil)
        
        let statisticVC = StatisticVC()
        let statisticNC = UINavigationController(rootViewController: statisticVC)
        statisticVC.tabBarItem = UITabBarItem(title: "Statistics",
                                              image: .init(systemName: "hare.fill"),
                                              selectedImage: nil)
        
        self.viewControllers = [trackerNC, statisticNC]
    }
}

