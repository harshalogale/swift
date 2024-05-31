//
//  AddCashIntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Foundation
import CashTrackerShared
import Intents
import CoreData

public class AddCashIntentHandler: NSObject, AddCashIntentHandling {
    
    // MARK: - Intents
    
    public func handle(intent: AddCashIntent, completion: @escaping (AddCashIntentResponse) -> Void) {
        print("handle AddCashIntent")
        
        let ctx = CashTrackerSharedHelper.persistentContainer.viewContext
        
        let cash = Credit(context: ctx)
        cash.id = UUID()
        cash.title = intent.title
        cash.amount = intent.amount?.amount?.doubleValue ?? 0.0
        cash.currencyCode = intent.amount?.currencyCode?.uppercased() ?? CashTrackerSharedHelper.currencyCode
        cash.datetime = Date()
        
        do {
           print("saving cash credit object")
           try ctx.save()
        } catch {
           print(error)
        }
        
        completion(AddCashIntentResponse.success(
            amount: intent.amount ?? INCurrencyAmount(amount: NSDecimalNumber(value: 0.0), currencyCode: Locale.current.currencyCode ?? "USD")))
    }

    public func resolveTitle(for intent: AddCashIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        print("resolveTitle = \(String(describing: intent.title))")
        
        if nil == intent.title || intent.title!.isEmpty {
            completion(INStringResolutionResult.needsValue())
        } else {
            completion(INStringResolutionResult.success(with: intent.title ?? "New Cash"))
        }
    }
    
    public func resolveAmount(for intent: AddCashIntent, with completion: @escaping (AddCashAmountResolutionResult) -> Void) {
        print("resolveAmount = \(String(describing: intent.amount))")
        
        let result: AddCashAmountResolutionResult
        
        if let currencyAmount = intent.amount, let amount = currencyAmount.amount {
            if amount.intValue < 0 {
                result = AddCashAmountResolutionResult.unsupported(forReason: AddCashAmountUnsupportedReason.lessThanMinimumValue)
            } else {
                result = AddCashAmountResolutionResult.success(with: intent.amount!)
            }
        } else {
            // No amount provided.
            result = AddCashAmountResolutionResult.needsValue()
        }
        
        completion(result)
    }
}
