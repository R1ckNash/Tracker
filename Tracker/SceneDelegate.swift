//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Ilia Liasin on 15/01/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        if UserDefaults.standard.bool(forKey: "isOnboardingCompleted") == true {
            window.rootViewController = TabBarController()
        } else {
            window.rootViewController = OnboardingVC()
        }
        
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
    }
    
}

