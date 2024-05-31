/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A single row to be displayed in a list of landmarks.
 */

import SwiftUI
import CashTrackerShared

struct ExpenseRow: View {
    @Binding var expense: Expense
    
    var body: some View {
        HStack {
            if nil != expense.imageData {
                Image(uiImage:UIImage(data: expense.imageData!)!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(6.0)
            } else {
                expense.image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(6.0)
            }
            
            VStack {
                HStack {
                    Text(expense.title ?? "")
                        .font(.title)
                    Spacer()
                }
                HStack {
                    Text(LocalizedStringKey(expense.category?.title ?? ""))
                        .font(.subheadline)
                    Spacer()
                }
                HStack {
                    Text((nil != expense.datetime ? DateFormatter.expDateTimeFormatter.string(from: expense.datetime!): ""))
                        .font(.footnote)
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                Text(CashTrackerSharedHelper.currencyFormatter.string(from:expense.amount as NSNumber) ?? "").font(.title).padding(15)
                Spacer()
            }
        }
    }
}
