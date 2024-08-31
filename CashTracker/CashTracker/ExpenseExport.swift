//
//  ExpenseExport.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import SwiftCSV
import Foundation
import MessageUI
import CashTrackerShared

struct ExpenseExport: View {
    private var expenses:[Expense]
    private var credits:[Credit]
    
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingActivityView = false
    @State private var isShowingMailView = false
    @State private var isShowingAlertNoEmail = false
    @State private var isShowingAlertNoData = false
    @State private var reportExp: Data? = nil
    @State private var reportCash: Data? = nil
    
    @State private var resultMail: Result<MFMailComposeResult, Error>?
    
    @State private var filesToShare = [Any]()
    
    init(_ expenses:[Expense],
         _ credits:[Credit]) {
        self.expenses = expenses
        self.credits = credits
    }
    
    func generateExpenseReportCSV() -> Data? {
        let csvStr = Expense.csv(expenses)
        
        // Converting it to Data.
        return csvStr.data(using: .utf8)
    }
    
    func generateCashReportCSV() -> Data? {
        let csvStr = Credit.csv(credits)
        
        // Converting it to Data.
        return csvStr.data(using: .utf8)
    }
    
    func exportReportToCSV() {
        reportExp = generateExpenseReportCSV()
        reportCash = generateCashReportCSV()
        
        // Write the text into a filepath and return the filepath in NSURL
        // Specify the file type you want the file be by changing the end of the filename (.txt, .json, .pdf...)
        let expReportURL = reportExp?.dataToFile(fileName: "cashtracker_report_expense_\(DateFormatter.timestampFormatter.string(from: Date())).csv")
        let cashReportURL = reportCash?.dataToFile(fileName: "cashtracker_report_cash_\(DateFormatter.timestampFormatter.string(from: Date())).csv")
        
        // Create the Array which includes the files you want to share
        filesToShare.removeAll()
        
        // Add the path of the expense report file to the Array
        if let expRep = expReportURL {
            filesToShare.append(expRep)
        }
        
        // Add the path of the cash report file to the Array
        if let cashRep = cashReportURL {
            filesToShare.append(cashRep)
        }
        
        if filesToShare.isEmpty {
            isShowingAlertNoData = true
        } else {
            // show ActivityViewController to allow the user to
            // appropriately handle the generated CSV report files
            isShowingActivityView = true
        }
    }
    
    func mailReportCSV() {
        reportExp = generateExpenseReportCSV()
        reportCash = generateCashReportCSV()
        
        if nil != reportExp || nil != reportCash {
            if (MFMailComposeViewController.canSendMail()) {
                isShowingMailView = true
            } else {
                isShowingAlertNoEmail = true
            }
        } else {
            isShowingAlertNoData = true
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    exportReportToCSV()
                }) {
                    HStack {
                        Image(systemName: "arrow.up.doc.fill")
                            .imageScale(.large)
                            .padding(.horizontal, 20)
                        Text("Export Report CSV")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .padding(.top, 40)
                .popover(isPresented: $isShowingActivityView) {
                    ActivityViewController(isShowing: $isShowingActivityView,
                                           filesToShare: filesToShare)
                }
                Spacer()
            }
            
            HStack {
                Button(action: {
                    mailReportCSV()
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .imageScale(.large)
                            .padding(.horizontal, 20)
                        Text("Email Report CSV")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: $isShowingMailView,
                             result: $resultMail,
                             exp: reportExp,
                             cash: reportCash)
                }
                Spacer()
            }
            
            Spacer()
        }
        .navigationTitle(Text("Export Report"))
    }
}

#Preview {
    ExpenseExport([], [])
}
