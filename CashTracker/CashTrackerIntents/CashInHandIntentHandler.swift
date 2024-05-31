//
//  CashInHandIntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Foundation
import CashTrackerShared
import Intents
import CoreLocation
import CoreData

public class CashInHandIntentHandler: NSObject, CashInHandIntentHandling {
    
    // MARK: - Intents
    
    public func handle(intent: CashInHandIntent, completion: @escaping (CashInHandIntentResponse) -> Void) {
        print("handle CashInHandIntent")
        
        let ctx = CashTrackerSharedHelper.persistentContainer.viewContext
        
        var cashInHand = 0.0
        
        print("============================")
        do {
            let allCash = try ctx.fetch(Credit.creditsFetchRequest())
            let allExp = try ctx.fetch(Expense.expensesFetchRequest())
            let totalCash = allCash.map( { $0.amount } ).reduce(0, +)
            let totalExp = allExp.map( { $0.amount } ).reduce(0, +)
            cashInHand = totalCash - totalExp
            print("Cash-in-hand = \(totalCash - totalExp)")
        } catch {
            print(error)
        }
        
        completion(CashInHandIntentResponse.success(
            amount: INCurrencyAmount(amount: NSDecimalNumber(value: cashInHand), currencyCode: Locale.current.currencyCode ?? "USD")))
    }
}
