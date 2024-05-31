//
//  CreditEntry.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import IntentsUI
import CashTrackerShared

struct CreditEntry: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var amt: String
    @State private var currencyCode: String
    @State private var notes: String
    @State private var dt: Date
    
    @State private var showCreditDatePicker = false
    
    @State private var width: CGFloat? = nil
    
    var credit: Binding<Credit?>
    
//    static var dateOnlyFormatter: DateFormatter {
//        autoreleasepool {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .medium
//            dateFormatter.timeStyle = .none
//            dateFormatter.locale = Locale.current
//            return dateFormatter
//        }
//    }
//
//    static var timeOnlyFormatter: DateFormatter {
//        autoreleasepool {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .none
//            dateFormatter.timeStyle = .short
//            dateFormatter.locale = Locale.current
//            return dateFormatter
//        }
//    }
    
    init(_ credit:Binding<Credit?>) {
        self.credit = credit
        
        let cred = self.credit.wrappedValue
        
        _title = State(initialValue: cred?.title ?? "")
        _dt = State(initialValue: cred?.datetime ?? Date())
        _amt = State(initialValue: String(describing: cred?.amount ?? 0.0))
        _notes = State(initialValue: cred?.notes ?? "")
        _currencyCode = State(initialValue: CashTrackerSharedHelper.currencyCode)
        
        donateInteraction()
    }
    
    private func donateInteraction() {
        let cashIntent = AddCashIntent()
        //cashIntent.title = "New Cash"
        //cashIntent.amount = INCurrencyAmount(amount: NSDecimalNumber(value: 0.0),
        //                                     currencyCode: Locale.current.currencyCode ?? "USD")
        cashIntent.suggestedInvocationPhrase = "Add Cash"
        
        let interaction = INInteraction(intent: cashIntent, response: nil)
        
        interaction.donate { error in
            guard error == nil else {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.localizedDescription)")
                } else {
                    print("Interaction donation failed: Unknown error")
                }
                return
            }
        }
    }
    
    var body: some View {
        autoreleasepool {
        Form {
            Section (header:
                        VStack {
                HStack {
                    Spacer()
                    Text("New Cash Entry").font(.title).bold()
                    Spacer()
                }
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "text.badge.xmark")
                            .imageScale(.large)
                            .foregroundColor(.red)
                        
                        Text("Cancel")
                            .foregroundColor(.red)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(5)
                            .padding(.trailing, 15)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let cred = self.credit.wrappedValue ?? Credit(context: self.managedObjectContext)
                        cred.id = self.credit.wrappedValue?.id ?? UUID()
                        cred.title = self.title.isEmpty ? "New Cash": self.title
                        
                        if let doubleAmt = Double(self.amt) {
                            cred.amount = doubleAmt
                        }
                        cred.currencyCode = self.currencyCode
                        cred.datetime = self.dt
                        cred.notes = self.notes
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.dt = Date()
                            self.title = ""
                            self.amt = "0.0"
                            self.notes = ""
                        }
                    }) {
                        HStack {
                            Image(systemName: nil != self.credit.wrappedValue ? "pencil.circle.fill": "plus.circle.fill")
                                .foregroundColor(self.title.isEmpty && 0 == (Double(self.amt) ?? 0) ? .gray: .green)
                                .imageScale(.large)
                            Text(nil != self.credit.wrappedValue ? "Update":  "Add").font(.headline).bold()
                        }
                    }.disabled(self.title.isEmpty && 0 == (Double(self.amt) ?? 0))
                        .opacity((self.title.isEmpty && 0 == (Double(self.amt) ?? 0)) ? 0.3: 1.0)
                }
            }) {
                HStack {
                    Text("Title").bold().padding(.trailing, 10)
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    TextField(LocalizedStringKey(stringLiteral: "Title"), text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Amount").bold().padding(.trailing, 10)
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    TextField(LocalizedStringKey(stringLiteral: "Amount"), text: $amt)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Date").bold().padding(.trailing, 10)
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    VStack {
                        Text("\(dt, formatter: DateFormatter.expDateOnlyFormatter)")
                            .padding(.trailing, 15)
                        Text("\(dt, formatter: DateFormatter.expTimeOnlyFormatter)")
                            .padding(.trailing, 15)
                    }
                    Spacer()
                    Button(action: {
                        self.showCreditDatePicker = true
                    }){
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.orange)
                                .imageScale(.large)
                            Text("Select Date")
                        }
                    }.sheet(isPresented: self.$showCreditDatePicker, content: {
                        DatePickerView("Select Date", self.$dt)
                    })
                    Spacer()
                }
                HStack {
                    Text(LocalizedStringKey(stringLiteral: "Notes")).bold().padding(.trailing, 10)
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    TextField(LocalizedStringKey(stringLiteral: "Notes"), text: $notes).lineLimit(Int(3))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }.onPreferenceChange(CenteringColumnPreferenceKey.self) { preferences in
                for p in preferences {
                    let oldWidth = self.width ?? CGFloat.zero
                    if p.width > oldWidth {
                        self.width = p.width
                    }
                }
            }
        }
        }
    }
}
