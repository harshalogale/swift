//
//  ExportReportIntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Foundation
import CashTrackerShared
import Intents
import CoreData
import MessageUI

public class ExportReportIntentHandler: NSObject, ExportReportIntentHandling {
    
    // MARK: - Intents
    
    public func handle(intent: ExportReportIntent, completion: @escaping (ExportReportIntentResponse) -> Void) {
        print("handle ExportReportIntent")
        
        let ctx = CashTrackerSharedHelper.persistentContainer.viewContext
        
        print("============================")
        do {
            let allCash = try ctx.fetch(Credit.allCreditsFetchRequest())
            let allExp = try ctx.fetch(Expense.allExpensesFetchRequest())
            
            exportReportToCSV(expenses: allExp, credits: allCash)
            
            completion(ExportReportIntentResponse.success(status:"Cash Report Emailed."))
        } catch {
            print (error)
            
            completion(ExportReportIntentResponse.failure(failureReason: "Error"))
        }
    }
    
    func generateExpenseReportCSV(expenses:[Expense]) -> Data? {
        let csvStr = Expense.csv(expenses)
        
        // Converting it to NSData.
        return csvStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
    
    func generateCashReportCSV(credits:[Credit]) -> Data? {
        let csvStr = Credit.csv(credits)
        
        // Converting it to NSData.
        return csvStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
    
    func exportReportToCSV(expenses:[Expense], credits:[Credit]) {
//        let reportExp = generateExpenseReportCSV(expenses: expenses)
//        let reportCash = generateCashReportCSV(credits: credits)
//
//        if nil != reportExp || nil != reportCash {
//            if (MFMailComposeViewController.canSendMail()) {
//                isShowingMailView = true
//            } else {
//                isShowingAlertNoEmail = true
//            }
//        }  else {
//            isShowingAlertNoData = true
//        }
    }
}
