//
//  ContentView.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import MapKit
import UIKit
import Combine
import CashTrackerShared

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var settings: UserSettings
    
    @State private var isCreditEntryFormVisible = false
    @State private var isExpenseEntryFormVisible = false
    
    // listen for UIScene app-became-active notification
    private let pub = NotificationCenter.default
        .publisher(for: UIScene.didActivateNotification, object: nil)
    
    private let pub1 = NotificationCenter.default
        .publisher(for: CashTrackerSharedHelper.UserSettingsChangedNotification, object: nil)
    
    @State private var forceRefresh: Bool
    
    init() {
        _forceRefresh = State(initialValue: false)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // dummy if-else to force app refresh when notification is received
                    if self.forceRefresh {
                        Spacer()
                    } else {
                        Spacer()
                    }
                    CashInHandView()
                        .environment(\.managedObjectContext, self.managedObjectContext)
                    Spacer()
                }
                .background(colorScheme == .dark ? Color(UIColor.systemGray5): Color.orange)
                .foregroundColor(colorScheme == .dark ? Color.orange: Color.black)
                .cornerRadius(8)
                .padding(Edge.Set(arrayLiteral: [.leading, .trailing]), 10)
                
                HStack {
                    VStack {
                        Image("addcash")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30).scaledToFit()
                        Text("Add Cash").fontWeight(.bold)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture() {
                        self.isCreditEntryFormVisible.toggle()
                    }
                    .padding(.leading, 20)
                    .popover(isPresented: self.$isCreditEntryFormVisible,
                             arrowEdge: .bottom) {
                                CreditEntry(.constant(nil))
                                    .environment(\.managedObjectContext, self.managedObjectContext)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image("expense")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30).scaledToFit()
                        Text("Add Expense").fontWeight(.bold)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture() {
                        self.isExpenseEntryFormVisible.toggle()
                    }
                    .padding(.leading, 10)
                    .popover(isPresented: self.$isExpenseEntryFormVisible,
                             arrowEdge: .bottom) {
                                ExpenseEntry(.constant(nil))
                                    .environment(\.managedObjectContext, self.managedObjectContext)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination:
                        ExpenseAnalysisContainer()
                            .environment(\.managedObjectContext, self.managedObjectContext))
                    {
                        VStack {
                            Image("analysis2")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30).scaledToFit()
                            Text("Analysis").font(.headline).fontWeight(.bold)
                        }
                    }
                    .foregroundColor(colorScheme == .dark ? .white: .black)
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    NavigationLink(destination:
                        SettingsView()
                            .environment(\.managedObjectContext, self.managedObjectContext)
                            .environmentObject(self.settings)
                        )
                    {
                        VStack {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30).scaledToFit()
                            Text("Settings").font(.headline).fontWeight(.bold)
                        }
                    }
                    .foregroundColor(colorScheme == .dark ? .white: .black)
                    .padding(.leading, 10)
                    .padding(.trailing, 20)
                }
                
                Divider()
                
                RecentCreditsList()
                    .environment(\.managedObjectContext, self.managedObjectContext)
                
                RecentExpensesList()
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
            .navigationBarTitle("Cash Expense Tracker")
        }
        .onReceive(pub, perform: { (_) in
            // update a state variable to force UI refresh
            self.forceRefresh.toggle()
        })
            .onReceive(pub1, perform: { (_) in
                // update a state variable to force UI refresh
                self.forceRefresh.toggle()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.locale, Locale(identifier: "hi"))
    }
}

struct CashInHandView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Credit.creditsFetchRequest()) private var credits: FetchedResults<Credit>
    
    @FetchRequest(fetchRequest: Expense.expensesFetchRequest()) private var expenses: FetchedResults<Expense>
    
    func sumOfCredits() -> Double {
        let total = credits.map({$0.amount}).reduce(0, +)
        return total
    }
    
    func sumOfExpenses() -> Double {
        let total = expenses.map({$0.amount}).reduce(0, +)
        return total
    }
    
    var body: some View {
        VStack {
            (Text("Cash In Hand") + Text(": "))
                .font(.headline).bold()
            Text(CashTrackerSharedHelper.currencyFormatter.string(from:(sumOfCredits() - sumOfExpenses()) as NSNumber) ?? "0.00").font(.largeTitle).fontWeight(.heavy)
        }
    }
}
