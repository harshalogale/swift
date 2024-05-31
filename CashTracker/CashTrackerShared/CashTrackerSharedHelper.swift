//
//  CashTrackerSharedHelper.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import Foundation
import SwiftUI
import CoreData
import Combine

// MARK: - General Helper Methods

public class CashTrackerSharedHelper: NSObject {
    
    public static let currencies = ["AED", "AUD", "BRL", "CHF", "CNY", "EUR", "GBP", "INR", "JPY", "USD"]
    
    public static let FirstStartCompleteKey = "firstStartComplete"
    
    @objc public static let CurrencyCodeKey = "currencyCode"
    @objc public static let DefaultCategoryIdKey = "defaultCategoryId"
    @objc public static let DefaultCategoryTitleKey = "defaultCategoryTitle"
    
    //@objc public static var DefaultCategory: Category
    
    public static let DefaultCurrencyCode = "USD"
    
    public static let UserSettingsChangedNotification = NSNotification.Name("UserSettingsChanged")
    
    public static var currencyCode: String {
        get {
            return UserDefaults.standard.string(forKey: CashTrackerSharedHelper.CurrencyCodeKey) ?? DefaultCurrencyCode
        }
        set(code) {
            UserDefaults.standard.set(code, forKey: CashTrackerSharedHelper.CurrencyCodeKey)
        }
    }
    
    public static var defaultCategoryId: String {
        get {
            return UserDefaults.standard.string(forKey: CashTrackerSharedHelper.DefaultCategoryIdKey) ??
                generateDefaultExpenseCategory().id.uuidString
        }
        set(categoryId) {
            UserDefaults.standard.set(categoryId, forKey: CashTrackerSharedHelper.DefaultCategoryIdKey)
        }
    }
    
    // MARK: - Core Data stack

    public static var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        
        let container = NSPersistentCloudKitContainer(name: "CashTracker")

        let storeUrl =  FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.techunfold.CashTracker")!.appendingPathComponent("CashTracker.sqlite")

        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = storeUrl

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

    public static func saveContext () {
        let context = CashTrackerSharedHelper.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private static func generateDefaultExpenseCategory() -> CashCategory {
        let ctx = persistentContainer.viewContext
        
        let defaultCat = CashCategory(context: ctx)
        defaultCat.id = UUID()
        defaultCat.title = CashCategory.uncategorizedCategoryTitle
        defaultCat.isDefault = true
        
        saveContext()
        
        // store value to user defaults storage
        defaultCategoryId = defaultCat.id.uuidString
        
        return defaultCat
    }
    
    public static func generatePreloadedExpenseCategories() {
        let ctx = persistentContainer.viewContext
        
        let _ = generateDefaultExpenseCategory()
        
        print("preloaded categories:")
        // create a few preloaded categories
        for title in CashCategory.preloadedCategories {
            print(title)
            let newCat = CashCategory(context: ctx)
            newCat.id = UUID()
            newCat.title = title
        }
        
        saveContext()
    }
    
    /// Get the current directory
    ///
    /// - Returns: the Current directory in NSURL
    public static func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    // MARK: - Currency Formatters

    public static var currencyFormatter: NumberFormatter {
        let f = NumberFormatter()
        // allow no currency symbol, extra digits, etc
        f.isLenient = true
        f.numberStyle = .currency
        f.currencyCode = CashTrackerSharedHelper.currencyCode
        f.locale = Locale.current
        return f
    }
}

// MARK: - DateFormatter Utilities

public extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let expDateOnlyFormatter: DateFormatter = {
        autoreleasepool {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale.current
            return dateFormatter
        }
    }()
    
    static let expDateTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    static let expTimeOnlyFormatter: DateFormatter = {
        autoreleasepool {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale.current
            return dateFormatter
        }
    }()

    static let expDateMonthOnlyFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    static let expMonthYearOnlyFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yy"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    static let expCSVFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    static let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
}

// MARK: - Date Utilities

public extension Date {
    var zeroSeconds: Date {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            return calendar.date(from: dateComponents)!
        }
    }
    
    var firstDateOfMonth: Date {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month], from: self)
            return calendar.date(from: dateComponents)!
        }
    }
    
    var lastDateOfMonth: Date {
        get {
            return Calendar.current.date(bySetting: .day, value: Calendar.current.range(of: .day, in: .month, for: self)!.last!, of: self)!
        }
    }
    
    var dayComponent: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
    }
}



extension Data {

    /// Data into file
    ///
    /// - Parameters:
    ///   - fileName: the Name of the file you want to write
    /// - Returns: Returns the URL where the new file is located in NSURL
    public func dataToFile(fileName: String) -> NSURL? {

        // Make a constant from the data
        let data = self

        // Make the file path (with the filename) where the file will be loacated after it is created
        let filePath = CashTrackerSharedHelper.getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            // Write the file from data into the filepath (if there will be an error, the code jumps to the catch block below)
            try data.write(to: URL(fileURLWithPath: filePath))

            // Returns the URL where the new file is located in NSURL
            return NSURL(fileURLWithPath: filePath)

        } catch {
            // Prints the localized description of the error from the do block
            print("Error writing the file: \(error.localizedDescription)")
        }

        // Returns nil if there was an error in the do-catch -block
        return nil

    }

}
