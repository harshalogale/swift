//
//  RecentExpensesList.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CoreData
import CashTrackerShared

struct RecentExpensesList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Expense.recentExpensesFetchRequest())
    var recentExpenses: FetchedResults<Expense>
    
    var body: some View {
        List {
            Section(header:
                HStack {
                    Text("Recent Expenses")
                        .font(.headline).bold().padding(.leading, 10)
                    Spacer()
                    NavigationLink(destination: ExpenseHistory()
                        .environment(\.managedObjectContext, self.managedObjectContext)) {
                            Text("Expense History").font(.subheadline).bold()
                            Image(systemName:"arrow.right.circle.fill")
                                .foregroundColor(.gray)
                    }
            }) {
                if recentExpenses.isEmpty {
                    HStack {
                        Spacer()
                        VStack {
                            Text("No Recent Expenses")
                                .font(.title).bold()
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }.padding(.vertical, 30)
                } else {
                    ForEach(recentExpenses, id: \.self) { expense in
                        NavigationLink(
                            destination: ExpenseDetail(expense)
                                .environment(\.managedObjectContext, self.managedObjectContext)
                        ) {
                            ExpenseRow(expense: .constant(expense))
                        }
                    }
                }
            }
        }
    }
}
