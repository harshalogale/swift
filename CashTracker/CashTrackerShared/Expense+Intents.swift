//
//  Expense+Intents.swift
//  CashTrackerKit
//
//  Created by Harshal Ogale
//

import Foundation
import Intents

extension Expense {
    var addExpenseIntent: AddExpenseIntent {
        let expenseIntent = AddExpenseIntent()
        print("expenseIntent default suggestion: \(expenseIntent.suggestedInvocationPhrase ?? "--none--")")
        expenseIntent.title = title
        //expenseIntent.amount = INCurrencyAmount(amount: NSDecimalNumber(value: amount), currencyCode: Locale.current.currencyCode ?? "USD")
        
        expenseIntent.suggestedInvocationPhrase = NSString.deferredLocalizedIntentsString(with: "ADD_EXPENSE_SUGGESTED_PHRASE") as String
        
        return expenseIntent
    }
}
