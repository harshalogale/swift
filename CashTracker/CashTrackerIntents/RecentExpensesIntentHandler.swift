//
//  RecentExpensesIntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Foundation
import CashTrackerShared
import Intents
import CoreLocation
import CoreData

public class RecentExpensesIntentHandler: NSObject, RecentExpensesIntentHandling {
    
    // MARK: - Intents
    
    public func handle(intent: RecentExpensesIntent, completion: @escaping (RecentExpensesIntentResponse) -> Void) {
        print("handle RecentExpensesIntent")
        
        let ctx = CashTrackerSharedHelper.persistentContainer.viewContext
        
        var recent = ""
        
        print("============================")
        do {
            let recentExp = try ctx.fetch(Expense.recentExpensesFetchRequest())
            
            print("Recent expenses:")
            
            for ex in recentExp {
                let amtStr = CashTrackerSharedHelper.currencyFormatter.string(from: ex.amount as NSNumber) ?? "0.00"
                let expStr = "\n\(ex.title!), \(amtStr)"
                recent += expStr
                print("\(ex.title!), \(ex.amount), (\(ex.latitude), \(ex.longitude))")
            }
        } catch {
            print (error)
        }
        
        completion(RecentExpensesIntentResponse.success(expenses: recent))
    }
}
