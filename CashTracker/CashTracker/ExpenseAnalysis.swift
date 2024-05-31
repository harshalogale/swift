//
//  ExpenseAnalysis.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CashTrackerShared


struct ExpenseAnalysisContainer: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(fetchRequest: Credit.creditsFetchRequest()) var credits: FetchedResults<Credit>

    @FetchRequest(fetchRequest: Expense.expensesFetchRequest()) var expenses: FetchedResults<Expense>
    
    // listen for UIScene app-became-active notification
    private let pub = NotificationCenter.default
        .publisher(for: UIScene.didActivateNotification, object: nil)
    
    @State private var forceRefresh = false
    
    var body: some View {
        VStack {
            // dummy if-else to force app refresh when notification is received
            if self.forceRefresh {
                EmptyView()
            } else {
                EmptyView()
            }
            ExpenseAnalysis(credits: credits, expenses: expenses)
        }
        .onReceive(pub, perform: { (_) in
            // update a state variable to force UI refresh
            self.forceRefresh.toggle()
        })
    }
}

struct ExpenseAnalysis: View {
    static let graphColors: [UIColor] = [.systemBlue, .orange, .green, .systemPink, .gray, .purple, .yellow, .systemRed, .cyan, .magenta, .systemIndigo, .systemTeal]
    
    private var credits: [Credit]
    private var expenses: [Expense]
    
    private var expByCategory: Dictionary<String?, [Expense]>?
    
    @State private var selectedChart = ExpenseChartType.Category
    
    @ObservedObject var chartConfig = SunburstConfiguration(nodes:[], calculationMode: .parentDependent(totalValue: nil))
    
    enum ExpenseChartType: String, CaseIterable {
        case Category
        case Date
        
        func image() -> Image {
            var img: Image!
            
            switch self {
            case .Category:
                img = Image(systemName: "chart.pie.fill")
            case .Date:
                img = Image(systemName: "chart.bar.fill")
            }
            
            return img
        }
    }
    
    init(credits:FetchedResults<Credit>, expenses:FetchedResults<Expense>) {
        self.credits = credits.compactMap( { $0 } )
        self.expenses = expenses.compactMap( { $0 } )
        
        expByCategory = Dictionary(grouping: expenses) { $0.category?.title ?? CashCategory.uncategorizedCategoryTitle }
        
        for (index, (catName, groupExp)) in expByCategory!.enumerated() {
            let node = Node(name: catName!,
                            value: Double(groupExp.map({ $0.amount }).reduce(0, +)),
                            backgroundColor: ExpenseAnalysis.graphColors[index % ExpenseAnalysis.graphColors.count])
            chartConfig.nodes.append(node)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: ExpenseExport(expenses, credits)) {
                    HStack {
                        Image(systemName: "square.and.arrow.up.fill")
                            .imageScale(.large)
                        Text("Export")
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 20)
                Spacer()
                Picker("Chart Type", selection: $selectedChart) {
                    Text(LocalizedStringKey(ExpenseChartType.Category.rawValue))
                        .tag(ExpenseChartType.Category)
                    Text(LocalizedStringKey(ExpenseChartType.Date.rawValue))
                        .tag(ExpenseChartType.Date)
                    }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.leading, 50)
            }
            
            if (selectedChart == ExpenseChartType.Category) {
                SunburstView(configuration: chartConfig)
                
                List {
                    Section (header:
                        HStack {
                            (Text("Expenses") + Text(": ")).font(.headline)
                            Text(LocalizedStringKey(chartConfig.selectedNode?.name ?? "All")).font(.title).fontWeight(.bold).padding(.leading, 15)
                            Spacer()
                    }) {
                        ForEach(
                            (nil != chartConfig.selectedNode
                                ? expByCategory![chartConfig.selectedNode!.name]!
                               : expenses.compactMap({ $0 }))
                        ) { exp in
                            HStack {
                                Text("\(exp.title ?? "no title")").padding(.leading, 10)
                                Spacer()
                                Text(CashTrackerSharedHelper.currencyFormatter.string(from:exp.amount as NSNumber) ?? "").padding(.trailing, 10)
                            }
                        }
                    }
                }.listStyle(GroupedListStyle())
                Spacer()
            } else {
                VStack {
                    ExpenseBarChart(expenses: .constant(expenses))
                    Spacer()
                }
            }
        }
        .navigationBarTitle(Text("Expense Analysis"))
    }
}
