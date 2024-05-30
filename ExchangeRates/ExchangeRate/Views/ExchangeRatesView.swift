//
//  ExchangeRatesView.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import SwiftUI

/// A view to let the user select a source currency code and displays the list of exchange rates to all other currency codes.
struct ExchangeRatesView: View {
    @EnvironmentObject var currencyList: CurrencyList
    @ObservedObject var viewModel: ExchangeRatesViewModel

    init(viewModel: ExchangeRatesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Text("Source Currency")
                    .font(.headline)
                    .bold()
                    .padding(.horizontal)
                Picker("Select Currency", selection: $viewModel.currencyCode) {
                    ForEach(currencyList.supportedCurrencies) { currency in
                        Text(currency.currencyCode)
                            .font(.title)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                Spacer()
            }
            HStack {
                Text("Target Currency")
                    .font(.headline)
                    .bold()
                    .padding(.horizontal)
                Spacer()
                Text("Rate")
                    .font(.headline)
                    .bold()
                    .padding(.horizontal)
            }
            .padding()
            ForEach(Array(viewModel.exchangeRates.keys.sorted()), id: \.self) { key in
                if let rate = viewModel.exchangeRates[key] {
                    HStack {
                        Text(key)
                            .padding(.horizontal)
                        Spacer()
                        Text(String(format: "%.5f", rate))
                            .monospaced()
                            .padding(.horizontal)
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Spacer()
                if let docsUrl = URL(string: viewModel.docsUrl) {
                    NavigationLink(destination: SafariView(url: docsUrl)) {
                        Image(systemName: "book.circle.fill")
                    }
                }
                if let termsUrl = URL(string: viewModel.termsUrl) {
                    NavigationLink(destination: SafariView(url: termsUrl)) {
                        Image(systemName: "info.circle.fill")
                    }
                }
            }
        }
        .onChange(of: viewModel.currencyCode) { newCurrencyCode in
            viewModel.currencySelected()
        }
        .navigationTitle("Exchange Rates")
    }
}

#Preview {
    ExchangeRatesView(viewModel: ExchangeRatesViewModel(webService: ERWebService()))
}
