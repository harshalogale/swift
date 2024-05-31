//
//  Expense+Intents.swift
//  CashTrackerKit
//
//  Created by Harshal Ogale
//

import Foundation
import Intents

extension Credit {
    var addCashIntent: AddCashIntent {
        let cashIntent = AddCashIntent()
        cashIntent.title = title
        cashIntent.amount = INCurrencyAmount(amount: NSDecimalNumber(value: amount), currencyCode: Locale.current.currencyCode ?? "USD")
        
        cashIntent.suggestedInvocationPhrase = NSString.deferredLocalizedIntentsString(with: "ADD_CASH_SUGGESTED_PHRASE") as String
        
        return cashIntent
    }
}
