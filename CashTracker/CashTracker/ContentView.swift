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

private enum SelectedView: String, CaseIterable, Identifiable {
    case RecentExpenses = "Recent Expenses"
    case RecentCredits = "Recent Credits"

    var id: String { rawValue }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @State private var isCreditEntryFormVisible = false
    @State private var isExpenseEntryFormVisible = false
    @State private var selectedSegment = 0
    
    // listen for UIScene app-became-active notification
    private let sceneActivated = NotificationCenter.default
        .publisher(for: UIScene.didActivateNotification, object: nil)
    
    private let settingsChanged = NotificationCenter.default
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
                    if forceRefresh {
                        Spacer()
                    } else {
                        Spacer()
                    }
                    CashInHandView()
                    Spacer()
                }
                .background(colorScheme == .dark ? Color(UIColor.systemGray5): Color.orange)
                .foregroundColor(colorScheme == .dark ? Color.orange: Color.black)
                .cornerRadius(8)
                .padding([.leading, .trailing], 10)
                
                Picker(selection: $selectedSegment,
                       label: EmptyView()) {
                    ForEach(SelectedView.allCases.indices, id: \.self) { index in
                        Text(SelectedView.allCases[index].rawValue).tag(index)
                    }
                }
                       .pickerStyle(SegmentedPickerStyle())
                       .padding([.leading, .trailing, .bottom])
                
                if selectedSegment == 0 {
                    RecentExpensesList()
                        .transition(.move(edge: .leading))
                } else {
                    RecentCreditsList()
                        .transition(.move(edge: .trailing))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Cash Expense Tracker")
            .animation(.easeInOut, value: selectedSegment)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    ToolbarView(isCreditEntryFormVisible: $isCreditEntryFormVisible,
                                isExpenseEntryFormVisible: $isExpenseEntryFormVisible)
                }
            }
            .onReceive(sceneActivated, perform: { (_) in
                // update a state variable to force UI refresh
                forceRefresh.toggle()
            })
            .onReceive(settingsChanged, perform: { (_) in
                // update a state variable to force UI refresh
                forceRefresh.toggle()
            })
        }
    }
}

#Preview {
    ContentView()
        .environment(\.locale, Locale(identifier: "hi"))
        .environmentObject(UserSettings())
}

struct ToolbarView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings

    @Binding var isCreditEntryFormVisible: Bool
    @Binding var isExpenseEntryFormVisible: Bool

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image("addcash")
                    .resizable()
                    .scaledToFit()
                Text("Add Cash")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .contentShape(Rectangle())
            .onTapGesture() {
                isCreditEntryFormVisible.toggle()
            }
            .padding(.leading, 20)
            .popover(isPresented: $isCreditEntryFormVisible,
                     arrowEdge: .bottom) {
                CreditEntry(.constant(nil))
            }

            Spacer()

            VStack {
                Image("expense")
                    .resizable()
                    .scaledToFit()
                Text("Add Expense")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .contentShape(Rectangle())
            .onTapGesture() {
                isExpenseEntryFormVisible.toggle()
            }
            .padding(.leading, 10)
            .popover(isPresented: $isExpenseEntryFormVisible,
                     arrowEdge: .bottom) {
                ExpenseEntry(.constant(nil))
            }

            Spacer()

            NavigationLink(destination:
                            ExpenseAnalysisContainer()
            )
            {
                VStack {
                    Image("analysis2")
                        .resizable()
                        .scaledToFit()
                    Text("Analysis")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(colorScheme == .dark ? .white: .black)
            .padding(.leading, 10)

            Spacer()

            NavigationLink(destination:
                            SettingsView()
                .environmentObject(settings)
            )
            {
                VStack {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                    Text("Settings")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(colorScheme == .dark ? .white: .black)
            .padding(.leading, 10)
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    ToolbarView(isCreditEntryFormVisible: .constant(false),
                isExpenseEntryFormVisible: .constant(false))
    .environment(\.locale, Locale(identifier: "hi"))
    .environment(\.colorScheme, .light)
    .environmentObject(UserSettings())
}

struct CashInHandView: View {
    @FetchRequest(fetchRequest: Credit.creditsFetchRequest()) private var credits: FetchedResults<Credit>
    @FetchRequest(fetchRequest: Expense.expensesFetchRequest()) private var expenses: FetchedResults<Expense>
    
    var sumOfCredits: Double {
        credits
            .map({$0.amount})
            .reduce(0, +)
    }
    
    var sumOfExpenses: Double {
        expenses
            .map({$0.amount})
            .reduce(0, +)
    }
    
    var body: some View {
        VStack {
            (Text("Cash In Hand") + Text(": "))
                .font(.headline).bold()
            Text(CashTrackerSharedHelper.currencyFormatter.string(from:(sumOfCredits - sumOfExpenses) as NSNumber) ?? "0.00").font(.largeTitle).fontWeight(.heavy)
        }
    }
}

//#Preview {
//    CashInHandView()
//}
