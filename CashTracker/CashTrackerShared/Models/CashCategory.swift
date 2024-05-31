//
//  CashCategory.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import Foundation
import CoreData

public class CashCategory: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var isDefault: Bool
    @NSManaged public var expenses: NSSet?
}

extension CashCategory {
    // create a few preloaded categories
    public static let preloadedCategories = ["Auto Fuel",
                                             "Education",
                                             "Fee",
                                             "Food",
                                             "Gift",
                                             "Grocery",
                                             "Household",
                                             "Kid",
                                             "Loan",
                                             "Medicine",
                                             "Miscellaneous",
                                             "Office",
                                             "Personal",
                                             "Public Transport",
                                             "Rent",
                                             "Restaurant",
                                             "School",
                                             "Service",
                                             "Sport",
                                             "Tool",
                                             "Utility Bill"]
    
    public static let uncategorizedCategoryTitle = "Uncategorized"
}

public extension CashCategory {
    static func allCashCategoriesFetchRequest() -> NSFetchRequest<CashCategory> {
        let request = CashCategory.fetchRequest() as! NSFetchRequest<CashCategory>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        return request
    }
}
