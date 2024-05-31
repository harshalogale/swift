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
    var expenses:[Expense]
    var credits:[Credit]
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingActivityView = false
    @State var isShowingMailView = false
    @State var isShowingAlertNoEmail = false
    @State var isShowingAlertNoData = false
    @State var reportExp: Data? = nil
    @State var reportCash: Data? = nil
    
    @State var resultMail: Result<MFMailComposeResult, Error>?
    
    @State var filesToShare = [Any]()
    
    init(_ expenses:[Expense], _ credits:[Credit]) {
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
            self.isShowingAlertNoData = true
        } else {
            // show ActivityViewController to allow the user to
            // appropriately handle the generated CSV report files
            self.isShowingActivityView = true
        }
    }
    
    func mailReportCSV() {
        reportExp = generateExpenseReportCSV()
        reportCash = generateCashReportCSV()
        
        if nil != reportExp || nil != reportCash {
            if (MFMailComposeViewController.canSendMail()) {
                self.isShowingMailView = true
            } else {
                self.isShowingAlertNoEmail = true
            }
        } else {
            self.isShowingAlertNoData = true
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.exportReportToCSV()
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
                    ActivityViewController(isShowing: self.$isShowingActivityView,
                                           filesToShare: self.filesToShare)
                }
                Spacer()
            }
            
            HStack {
                Button(action: {
                    self.mailReportCSV()
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
                    MailView(isShowing: self.$isShowingMailView,
                             result: self.$resultMail,
                             exp: self.reportExp,
                             cash: self.reportCash)
                }
                Spacer()
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Export Report"))
    }
}

struct ExpenseExport_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseExport([], [])
    }
}
