//
//  OnboardingVC.swift
//  Tracker
//
//  Created by Ilia Liasin on 23/02/2025.
//

import UIKit

final class OnboardingVC: UIPageViewController {
    
    // MARK: - UI Elements
    
    private lazy var customPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .init(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        pageControl.pageIndicatorTintColor = .init(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.30)
        return pageControl
    }()
    
    // MARK: - Private Properties
    
    private var pages: [UIViewController] = [
        OnboardingPageVC(textTitle: "Track only what you want",
                         image: UIImage(named: "backgroundBlue") ?? UIImage()),
        
        OnboardingPageVC(textTitle: "Even if it's not liters of water and yoga",
                         image: UIImage(named: "backgroundRed") ?? UIImage())
    ]
    
    // MARK: - Initializers
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        configureUI()
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        
        view.addSubview(customPageControl)
        customPageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customPageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                      constant: -140),
            customPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customPageControl.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentVC) else { return }
        
        customPageControl.currentPage = currentIndex
    }
}
