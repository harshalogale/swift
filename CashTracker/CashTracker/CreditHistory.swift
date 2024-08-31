//
//  CreditHistory.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CoreData
import IntentsUI
import CashTrackerShared

struct CreditHistory: View {
    @Environment(\.editMode) var editMode
    
    @State private var showingSortFilter = false
    @State private var showingAddNew = false
    
    @State private var sortOrder = SortListView.SortOrder.Descending
    @State private var sortOn = "datetime"
    @State private var sortableColumns = Credit.sortableProperties
    
    @State private var startDate: Date = Date().firstDateOfMonth
    @State private var endDate: Date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
    
    // listen for UIScene app-became-active notification
    private let pub = NotificationCenter.default
        .publisher(for: UIScene.didActivateNotification, object: nil)
    
    @State private var forceRefresh = false
    
    init() {
        donateInteraction()
    }
    
    private func donateInteraction() {
        let cashIntent = RecentCashIntent()
        cashIntent.suggestedInvocationPhrase = "Recent Cash Additions"
        
        let interaction = INInteraction(intent: cashIntent, response: nil)
        
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
    
    var body: some View {
        VStack {
            Section(header:
                HStack {
                    Text("Credit List").font(.headline).padding(.leading, 10)
                    
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
                    CashCreditList($startDate, $endDate, $sortOn, $sortOrder)
                }
            }
            .navigationTitle(Text("Cash Addition History"))
            .onReceive(pub, perform: { (_) in
                // update a state variable to force UI refresh
                forceRefresh.toggle()
            })
        }
    }
}


struct CashCreditList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    private var fromDate: Binding<Date>
    private var toDate: Binding<Date>
    private var sortOn: Binding<String>
    private var sortOrder: Binding<SortListView.SortOrder>
    
    private var creditsRequest: FetchRequest<Credit>
    private var credits: FetchedResults<Credit> { creditsRequest.wrappedValue }
    
    init(_ from: Binding<Date>,
         _ to: Binding<Date>,
         _ sortOn: Binding<String>,
         _ sortOrder: Binding<SortListView.SortOrder>) {
        self.fromDate = from
        self.toDate = to
        self.sortOn = sortOn
        self.sortOrder = sortOrder
        
        creditsRequest = FetchRequest<Credit>(
            entity: Credit.entity(),
            sortDescriptors: [NSSortDescriptor(key: sortOn.wrappedValue, ascending: sortOrder.wrappedValue == SortListView.SortOrder.Ascending)],
            predicate: NSPredicate(format: "datetime >= %@ && datetime <= %@ && currencyCode like[c] %@",
                                   fromDate.wrappedValue as NSDate,
                                   toDate.wrappedValue as NSDate,
                                   CashTrackerSharedHelper.currencyCode))
    }
    
    var body: some View {
        List {
            if credits.isEmpty {
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
                ForEach(credits, id:\.self) { credit in
                    NavigationLink(
                        destination: CreditDetail(credit)
                    ) {
                        CreditRow(credit: .constant(credit))
                    }
                }
                    .onDelete { (indexSet) in // Delete gets triggered by swiping left on a row
                        // ❇️ Gets the Credit instance out of the result credits array
                        // ❇️ and deletes it using the @Environment's managedObjectContext
                        let creditToDelete = credits[indexSet.first!]
                        managedObjectContext.delete(creditToDelete)
                        
                        // Note: !! App crashes without this delay !!
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            do {
                                try managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    CashCreditList(
        .constant(Date().addingTimeInterval(-36000)),
        .constant(Date()),
        .constant("datetime"),
        .constant(SortListView.SortOrder.Descending)
    )
    .environment(\.managedObjectContext, CashTrackerSharedHelper.persistentContainer.viewContext)
}

struct CreditRow: View {
    @Binding var credit: Credit
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(credit.title ?? "").font(.title)
                    Spacer()
                    
                    Text(CashTrackerSharedHelper.currencyFormatter.string(from: credit.amount as NSNumber) ?? "").font(.title).padding(15)
                }
                HStack {
                    Text((nil != credit.datetime ? DateFormatter.expDateTimeFormatter.string(from: credit.datetime!): ""))
                        .font(.subheadline)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
