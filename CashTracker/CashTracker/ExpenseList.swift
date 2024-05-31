//
//  ExpenseList.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import Foundation
import CoreData
import CashTrackerShared

struct ExpenseList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    private var fromDate: Binding<Date>
    private var toDate: Binding<Date>
    private var sortOn: Binding<String>
    private var sortOrder: Binding<SortListView.SortOrder>
    
    private var expensesRequest: FetchRequest<Expense>
    private var expenses: FetchedResults<Expense> { expensesRequest.wrappedValue }
    
    init(_ from:Binding<Date>, _ to:Binding<Date>, _ sortOn: Binding<String>, _ sortOrder: Binding<SortListView.SortOrder>) {
        self.fromDate = from
        self.toDate = to
        self.sortOn = sortOn
        self.sortOrder = sortOrder
        
        self.expensesRequest = FetchRequest(
            entity: Expense.entity(),
            sortDescriptors: [NSSortDescriptor(key: self.sortOn.wrappedValue, ascending: self.sortOrder.wrappedValue == SortListView.SortOrder.Ascending)],
            predicate: NSPredicate(format: "datetime >= %@ && datetime <= %@ && currencyCode like[c] %@",
                                   self.fromDate.wrappedValue as NSDate,
                                   self.toDate.wrappedValue as NSDate,
                                   CashTrackerSharedHelper.currencyCode))
    }
    
    var body: some View {
        List {
            if expenses.isEmpty {
                HStack {
                    Spacer()
                    VStack {
                        Text("No Entries With The Current Filters")
                            .font(.title).bold().multilineTextAlignment(.center)
                            .padding(.vertical, 30)
                    }
                    Spacer()
                }
            } else {
                ForEach(expenses, id:\.self) { expense in
                    NavigationLink(
                        destination: ExpenseDetail(expense)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    ) {
                        ExpenseRow(expense: .constant(expense))
                    }
                }
                    .onDelete { (indexSet) in // Delete gets triggered by swiping left on a row
                        // ❇️ Gets the Expense instance out of the result expenses array
                        // ❇️ and deletes it using the @Environment's managedObjectContext
                        let expenseToDelete = self.expenses[indexSet.first!]
                        self.managedObjectContext.delete(expenseToDelete)
                        
                        // Note: !! App crashes without this delay !!
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        }
                }
            }
        }
    }
}
