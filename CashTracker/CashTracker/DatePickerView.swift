//
//  DatePickerView.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CashTrackerShared

struct DatePickerView: View {
    @Environment(\.dismiss) var dismiss
    
    var date: Binding<Date>
    
    var title: String
    @State private var pickerDate: Date = Date()
    var innerPickerDate: Date?
    
    init(_ title: String?,
         _ selectedDate: Binding<Date>) {
        self.title = title ?? "Select Date"
        self.date = selectedDate
        self.pickerDate = selectedDate.wrappedValue
        self.innerPickerDate = selectedDate.wrappedValue
    }
    
    var body: some View {
        Section(header: Text(LocalizedStringKey(title))) {
            VStack {
                HStack () {
                    Spacer()
                    Button(action: {
                        dismiss()
                    } ) {
                        HStack {
                            Image(systemName: "text.badge.xmark")
                                .imageScale(.large)
                                .foregroundColor(.red)
                            Text("Cancel")
                                .foregroundColor(Color.red)
                                .padding(.leading, 10)
                        }
                    }
                    Spacer()
                    Button(action: {
                        pickerDate = pickerDate.zeroSeconds
                        date.wrappedValue = pickerDate
                        dismiss()
                    } ) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.medium)
                                .foregroundColor(.green)
                            
                            Text("Select")
                                .bold()
                                .padding(.trailing, 10)
                        }
                    }
                    Spacer()
                }
                HStack () {
                    Spacer()
                    DatePicker("", selection: $pickerDate).onAppear() {
                        $pickerDate.wrappedValue = innerPickerDate!
                    }
                    Spacer()
                }
                Spacer()
            }
        }.font(.title)
    }
}

#Preview {
    DatePickerView("Select Date", .constant(Date()))
}
