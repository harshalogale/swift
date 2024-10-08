//
//  RecentCreditsList.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CoreData
import CashTrackerShared

struct RecentCreditsList: View {
    @FetchRequest(fetchRequest: Credit.recentCreditsFetchRequest()) private var recentCredits: FetchedResults<Credit>
    
    var body: some View {
        List {
            Section(header:
                        HStack {
                Text("Recent Credits")
                    .font(.headline)
                    .bold()
                    .padding(.leading, 10)
                Spacer()
                NavigationLink(destination: CreditHistory()) {
                    Text("Cash Addition History")
                        .font(.subheadline)
                        .bold()
                    Image(systemName:"arrow.right.circle.fill")
                        .foregroundColor(.gray)
                }
            }) {
                if recentCredits.isEmpty {
                    HStack {
                        Spacer()
                        VStack {
                            Text("No Recent Cash Additions")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }.padding(.vertical, 30)
                } else {
                    ForEach(recentCredits, id: \.self) { credit in
                        NavigationLink(
                            destination: CreditDetail(credit)
                        ) {
                            CreditRow(credit: .constant(credit))
                        }
                    }
                }
            }
        }
    }
}
