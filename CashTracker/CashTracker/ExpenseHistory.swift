//
//  ExpenseHistory.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import IntentsUI
import CashTrackerShared

struct ExpenseHistory: View {
    @Environment(\.editMode) var editMode
    
    @State private var showingSortFilter = false
    @State private var showingAddNew = false
    
    @State private var sortOrder = SortListView.SortOrder.Descending
    @State private var sortOn = "datetime"
    @State private var sortableColumns = Expense.sortableProperties
    
    @State private var startDate: Date = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.day, from: Date()) + 1, to: Date(), wrappingComponents: false) ?? Date())
    @State private var endDate: Date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
    
    init() {
        donateInteraction()
    }
    
    private func donateInteraction() {
        let expIntent = RecentExpensesIntent()
        expIntent.suggestedInvocationPhrase = "Recent Expenses"
        
        let interaction = INInteraction(intent: expIntent, response: nil)
        
        interaction.donate { error in
            guard error == nil else {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.localizedDescription)")
                } else {
                    print("Interaction donation failed: Unknown error")
                }
                return
            }
        }
    }
    
    // listen for UIScene app-became-active notification
    private let pub = NotificationCenter.default
        .publisher(for: UIScene.didActivateNotification, object: nil)
    
    @State private var forceRefresh = false
    
    var body: some View {
        VStack {
            Section(header:
                HStack {
                    Text("Expense List").font(.headline).padding(.leading, 10)
                    
                    // dummy if-else to force app refresh when notification is received
                    if forceRefresh {
                        Spacer()
                    } else {
                        Spacer()
                    }
                    
                    Button(action: {
                        showingSortFilter = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .foregroundColor(.orange)
                                .imageScale(.large)
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .foregroundColor(.orange)
                                .imageScale(.large)
                            Text("Sort/Filter")
                        }
                    }
                    .sheet(isPresented: $showingSortFilter, content: {
                        SortFilterView(startDate: $startDate,
                                       endDate: $endDate,
                                       sortOrder: $sortOrder,
                                       sortOn: $sortOn,
                                       sortableColumns: $sortableColumns)
                    })
                    
                    Button(action: {
                        editMode?.wrappedValue = .active == editMode?.wrappedValue ? .inactive: .active
                    }) {
                        HStack {
                            Image(systemName: .active == editMode?.wrappedValue ? "pencil.circle": "pencil.circle.fill")
                                .foregroundColor(.orange)
                                .imageScale(.large)
                            Text(.active == editMode?.wrappedValue ? "Done": "Edit")
                        }
                    }.padding(.horizontal, 10)
                }
            ) {
                withAnimation(.linear(duration: 0.6)) {
                    ExpenseList($startDate, $endDate, $sortOn, $sortOrder)
                }
            }
            .navigationTitle(Text("Expense History"))
        }
        .onReceive(pub, perform: { (_) in
            // update a state variable to force UI refresh
            forceRefresh.toggle()
        })
    }
}

#Preview {
    ExpenseHistory().environment(\.locale, Locale(identifier: "hi"))
}
