//
//  DatePickerView.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CashTrackerShared

struct DatePickerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var date: Binding<Date>
    
    var title: String
    @State var pickerDate: Date = Date()
    var innerPickerDate: Date?
    
    init(_ title:String?, _ selectedDate:Binding<Date>) {
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
                        self.presentationMode.wrappedValue.dismiss()
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
                        self.pickerDate = self.pickerDate.zeroSeconds
                        self.date.wrappedValue = self.pickerDate
                        self.presentationMode.wrappedValue.dismiss()
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
                        self.$pickerDate.wrappedValue = self.innerPickerDate!
                    }
                    Spacer()
                }
                Spacer()
            }
        }.font(.title)
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView("Select Date", .constant(Date()))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
