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
    @State private var credit: Credit!
    
    @State private var isCreditEditFormVisible = false
    
    init(_ credit: Credit) {
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
                    isCreditEditFormVisible.toggle()
                }
                .padding(.horizontal, 10)
                .popover(isPresented: $isCreditEditFormVisible,
                         arrowEdge: .bottom) {
                            CreditEntry($credit)
                }
            }
            
            HStack {
                Text(CashTrackerSharedHelper.currencyFormatter.string(from: credit!.amount as NSNumber) ?? "").font(.title)
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
        .navigationTitle("Cash Addition Details")
    }
}

#Preview {
    let context = CashTrackerSharedHelper.persistentContainer.viewContext
    CreditDetail(Credit(context: context))
}
