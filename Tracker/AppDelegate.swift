//
//  AppDelegate.swift
//  Tracker
//
//  Created by Ilia Liasin on 15/01/2025.
//

import UIKit
import CoreData
import AppMetricaCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = AppMetricaConfiguration(apiKey: "36124f65-04b9-4db4-bb06-eb9c59c49e9d")
        AppMetrica.activate(with: configuration!)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}

