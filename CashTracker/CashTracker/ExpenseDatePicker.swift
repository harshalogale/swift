//
//  ExpenseDatePicker.swift
//  CashTracker
//
//  Created by Harshal Ogale on 23/10/19.
//  Copyright © 2019 Harshal Ogale. All rights reserved.
//

import SwiftUI

struct ExpenseDatePicker: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var date : Binding<Date>
    
    var title : String
    @State var pickerDate : Date = Date()
    var innerPickerDate : Date?
    
    init(_ title:String?, _ selectedDate:Binding<Date>) {
        self.title = title ?? "Select Date"
        self.date = selectedDate
        self.pickerDate = selectedDate.wrappedValue
        self.innerPickerDate = selectedDate.wrappedValue
    }
    
    var body: some View {
        Section(header: Text(LocalizedStringKey(title))) {
            VStack {
                DatePicker("", selection: $pickerDate).onAppear() {
                    self.$pickerDate.wrappedValue = self.innerPickerDate!
                }
                HStack () {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    } ) {
                        Text("Cancel")
                            .foregroundColor(Color.red)
                            .padding(.leading, 10)
                    }
                    Spacer()
                    Button(action: {
                        self.pickerDate = Calendar.current.date(bySetting: .second, value: 0, of: self.pickerDate)!
                        self.date.wrappedValue = self.pickerDate
                        self.presentationMode.wrappedValue.dismiss()
                    } ) {
                        Text("Select")
                            .bold()
                            .padding(.trailing, 10)
                    }
                    Spacer()
                }
                Spacer()
            }
        }.font(.title)
    }
}

//struct CounterDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpenseDatePicker()
//    }
//}
