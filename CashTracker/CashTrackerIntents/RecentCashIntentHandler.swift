//
//  RecentCashIntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Foundation
import CashTrackerShared
import Intents
import CoreLocation
import CoreData

public class RecentCashIntentHandler: NSObject, RecentCashIntentHandling {
    
    // MARK: - Intents
    
    public func handle(intent: RecentCashIntent, completion: @escaping (RecentCashIntentResponse) -> Void) {
        print("handle RecentCashIntent")
        
        let ctx = CashTrackerSharedHelper.persistentContainer.viewContext
        
        var recent = ""
        
        print("============================")
        do {
            let recentCash = try ctx.fetch(Credit.recentCreditsFetchRequest())
            
            print("Recent cash additions:")
            
            for csh in recentCash {
                let amtStr = CashTrackerSharedHelper.currencyFormatter.string(from: csh.amount as NSNumber) ?? "0.00"
                let cshStr = "\n\(csh.title!), \(amtStr)"
                recent += cshStr
                print("\(csh.title!), \(csh.amount)")
            }
        } catch {
            print (error)
        }
        
        completion(RecentCashIntentResponse.success(cash: recent))
    }
}
