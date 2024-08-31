//
//  SortFilterView.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CashTrackerShared

struct SortFilterView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @Binding var sortOrder: SortListView.SortOrder
    @Binding var sortOn: String
    @Binding var sortableColumns: [String]
    
    var body: some View {
        VStack {
            HStack {
                Text("Sort/Filter Selection")
                    .font(.title).fontWeight(.bold).padding(.leading, 15)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.headline).fontWeight(.bold).padding(5).padding(.trailing, 15)
                }
                .padding(.trailing, 10)
            }
            FilterListView(startDate: $startDate, endDate: $endDate)

            Divider()

            SortListView(sortOrder: $sortOrder, sortOn: $sortOn, sortableColumns: $sortableColumns)
        }
    }
}

#Preview {
    SortFilterView(startDate: .constant(Date()),
                   endDate: .constant(Date().addingTimeInterval(36000)),
                   sortOrder: .constant(SortListView.SortOrder.Descending),
                   sortOn: .constant("datetime"),
                   sortableColumns: .constant(["ColA", "ColB", "ColC"]))
}


struct SortListView: View {

    public enum SortOrder: String, CaseIterable {
        case Ascending
        case Descending
    }
    
    @Binding var sortOrder: SortOrder
    @Binding var sortOn: String
    @Binding var sortableColumns: [String]
    
    var body: some View {
        VStack {
            Section(header: HStack {
                Text("Sort Order")
                    .font(.headline)
                    .foregroundColor(Color.black.opacity(0.6))
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .padding(.leading, 20)
                Spacer()
            }.background(Color.gray.opacity(0.2))) {
                Picker("Sort Order", selection: $sortOrder) {
                    ForEach(SortListView.SortOrder.allCases, id: \.self) {
                        Text(LocalizedStringKey($0.rawValue))
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            List {
                Section(header: Text("Sort On").font(.headline)) {
                    ForEach($sortableColumns.wrappedValue, id: \.self) { prop in
                        HStack {
                            Text(LocalizedStringKey(prop.capitalized))
                            Spacer()
                            if sortOn == prop {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.gray)
                                    .imageScale(.large)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            sortOn = prop
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}

struct FilterListView: View {
    @State private var modalDisplayed1 = false
    @State private var modalDisplayed2 = false
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        Section(header: HStack {
            Text("Filters")
                .font(.headline)
                .foregroundColor(Color.black.opacity(0.6))
                .padding(.top, 8)
                .padding(.bottom, 8)
                .padding(.leading, 20)
            Spacer()
        }.background(Color.gray.opacity(0.2))) {
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        modalDisplayed1 = true
                    } ) {
                        Text("Start Date")
                            .font(.headline)
                            .padding(2)
                            .padding(.leading, 10)
                    }
                    .sheet(isPresented: $modalDisplayed1) {
                        Spacer()
                        DatePickerView("Update Start Date", $startDate)
                    }
                    Text("\(DateFormatter.expDateOnlyFormatter.string(from: startDate))")
                        .font(.subheadline)
                        .padding(2)
                        .padding(.leading, 10)
                    Text("\(DateFormatter.expTimeOnlyFormatter.string(from: startDate))")
                        .padding(2)
                        .padding(.leading, 10)
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        modalDisplayed2 = true
                    } ) {
                        Text("End Date")
                            .font(.headline)
                            .padding(2)
                            .padding(.leading, 10)
                    }
                    .sheet(isPresented: $modalDisplayed2) {
                        DatePickerView("Update End Date", $endDate)
                    }
                    Text("\(DateFormatter.expDateOnlyFormatter.string(from: endDate))")
                        .font(.subheadline)
                        .padding(2)
                        .padding(.leading, 10)
                    Text("\(DateFormatter.expTimeOnlyFormatter.string(from: endDate))")
                        .padding(2)
                        .padding(.leading, 10)
                }
                Spacer()
            }
        }
    }
}
