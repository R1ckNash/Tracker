//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Ilia Liasin on 15/01/2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        if UserDefaultsService.shared.isOnboardingCompleted() {
            window.rootViewController = TabBarController()
        } else {
            let onboardingVC = OnboardingVC()
            onboardingVC.onFinish = { [weak self] in
                guard let window = self?.window else { return }
                window.rootViewController = TabBarController()
                UIView.transition(with: window,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
            }
            window.rootViewController = onboardingVC
        }
        
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
    }
    
}

