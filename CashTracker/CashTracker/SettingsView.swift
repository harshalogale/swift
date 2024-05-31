//
//  SettingsView.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import Combine
import CashTrackerShared

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var settings: UserSettings
    
    // NOTE: !!! App crashes if an excessively long data set is used for Picker !!!
    //Locale.commonISOCurrencyCodes
    
    var body: some View {
        Form {
            Section(header: HStack {
                Image("currency")
                .resizable()
                .frame(maxWidth: 30, maxHeight: 30).scaledToFit()
                Text("Currency").font(.headline)
            }) {
                HStack {
                    (Text("Selected Currency") + Text(": "))
                        .font(.headline).fontWeight(.bold)
                    Spacer()
                    
                    NavigationLink(destination: CurrencyPickerView(
                        selectedCurrency: $settings.currencyCode,
                        currencies: CashTrackerSharedHelper.currencies)
                    ) {
                        VStack {
                            HStack {
                                Text("\(settings.currencyCode)")
                                    .font(.title)
                                    .bold()
                                    .padding(.horizontal, 10)
                                Spacer()
                            }
                            HStack {
                                Text(Locale.current.localizedString(forCurrencyCode: settings.currencyCode) ?? "")
                                    .padding(.horizontal, 10)
                                Spacer()
                            }
                        }
                    }
                }
            }
            
            Section(header:
                HStack {
                    Image("siri")
                        .renderingMode(.original)
                        .resizable()
                        .frame(maxWidth: 30, maxHeight: 30).scaledToFit()
                    (Text("Siri ").italic() + Text("Shortcuts").italic()).font(.headline)
            }) {
                SiriShortcuts()
            }
        }
        .navigationBarTitle("Settings")
    }
}


struct CurrencyPickerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var selectedCurrency: String
    
    var currencies: [String]
    
    var body: some View {
        List {
            ForEach(currencies, id: \.self) { currency in
                HStack {
                    Text(verbatim: currency
                        + " - "
                        + (Locale.current.localizedString(forCurrencyCode: currency) ?? "")
                    )
                        .bold()
                    
                    Spacer()
                    if currency == self.selectedCurrency {
                        Image(systemName: "checkmark")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectedCurrency = currency
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserSettings())
    }
}

struct CurrencyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPickerView(
            selectedCurrency: .constant("CHF"),
            currencies: CashTrackerSharedHelper.currencies)
            .environmentObject(UserSettings())
    }
}
