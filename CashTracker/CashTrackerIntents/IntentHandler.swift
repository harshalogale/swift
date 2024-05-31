//
//  IntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Intents
import CashTrackerShared
import UIKit
import CoreLocation

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        if intent is AddExpenseIntent {
            return AddExpenseIntentHandler()
        } else if intent is AddCashIntent {
            return AddCashIntentHandler()
        } else if intent is CashInHandIntent {
            return CashInHandIntentHandler()
        } else if intent is RecentExpensesIntent {
            return RecentExpensesIntentHandler()
        } else if intent is RecentCashIntent {
            return RecentCashIntentHandler()
        } else if intent is AddPaymentIntent {
            return AddPaymentIntentHandler()
        }
//        else if intent is ExportReportIntent {
//            return ExportReportIntentHandler()
//        }
        
        return self
    }
    
}
