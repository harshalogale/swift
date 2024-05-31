//
//  CreditDetail.swift
//  CashTracker
//  Abstract:
//  A view showing the details for a cash credit.
//
//  Created by Harshal Ogale

import SwiftUI
import CashTrackerShared

struct CreditDetail: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var credit: Credit!
    
    @State private var isCreditEditFormVisible = false
    
    init(_ credit:Credit) {
        _credit = State(initialValue: credit)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(verbatim: credit!.title ?? "")
                    .font(.largeTitle)
                
                Spacer()
                
                VStack {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.large)
                    
                    Text("Edit").fontWeight(.bold)
                }
                .contentShape(Rectangle())
                .onTapGesture() {
                    self.isCreditEditFormVisible.toggle()
                }
                .padding(.horizontal, 10)
                .popover(isPresented: self.$isCreditEditFormVisible,
                         arrowEdge: .bottom) {
                            CreditEntry(self.$credit)
                                .environment(\.managedObjectContext, self.managedObjectContext)
                }
            }
            
            HStack {
                Text(CashTrackerSharedHelper.currencyFormatter.string(from:credit!.amount as NSNumber) ?? "").font(.title)
                Spacer()
            }
            
            HStack {
                Text((nil != credit!.datetime ? DateFormatter.expDateTimeFormatter.string(from: credit!.datetime!): ""))
                    .font(.subheadline)
                Spacer()
            }
            
            Text("Notes").font(.headline) + Text(":").font(.headline)
            HStack {
                Text(verbatim: credit!.notes ?? "")
                    .font(.subheadline)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .padding(.top, 20)
        .navigationBarTitle("Cash Addition Details")
    }
}
