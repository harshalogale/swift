//
//  AppDelegate.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import UIKit
import CoreData
import CashTrackerShared

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let firstStartStatus = UserDefaults.standard.bool(forKey: CashTrackerSharedHelper.FirstStartCompleteKey)
        if !firstStartStatus {
            // run only on the first launch of the app
            UserDefaults.standard.set(true, forKey: CashTrackerSharedHelper.FirstStartCompleteKey)
            
            CashTrackerSharedHelper.currencyCode = Locale.current.currencyCode ?? "USD"
            
            UserDefaults.standard.set(CashTrackerSharedHelper.currencyCode, forKey: CashTrackerSharedHelper.CurrencyCodeKey)
            
            CashTrackerSharedHelper.generatePreloadedExpenseCategories()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

