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
    @ObservedObject private var viewModel: ExchangeRatesViewModel

    init(viewModel: ExchangeRatesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                VStack {
                    Text("Source Currency")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                }
                VStack {
                    if #available(iOS 18.0, *) {
                        Picker("", selection: $viewModel.currencyCode) {
                            ForEach(currencyList.currencies) { currency in
                                Text(currency.currencyCode) + Text(": ") + Text(currency.currencyName)
                            }
                        } currentValueLabel: {
                            if let _ = currencyList[viewModel.currencyCode] {
                                Text(viewModel.currencyCode)
                            }
                        }
                    } else {
                        Picker("", selection: $viewModel.currencyCode) {
                            ForEach(currencyList.currencies) { currency in
                                Text(currency.currencyCode)
                                    .font(.largeTitle)
                            }
                        }
                    }
                    if let currency = currencyList[viewModel.currencyCode] {
                        Text(currency.currencyName)
                            .font(.caption)
                            .padding(.bottom)
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
                Spacer()
            }
            List {
                ForEach(Array(viewModel.exchangeRates.keys.sorted()), id: \.self) { key in
                    if let rate = viewModel.exchangeRates[key] {
                        HStack {
                            VStack {
                                HStack {
                                    Text(key)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                if let currency = currencyList[key] {
                                    HStack {
                                        Text(currency.currencyName)
                                            .padding(.horizontal)
                                            .font(.caption)
                                        Spacer()
                                    }
                                }
                            }
                            Spacer()
                            Text(String(format: "%.5f", rate))
                                .monospaced()
                                .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Spacer()
                if let _ = URL(string: viewModel.docsUrl) {
                    Button("", systemImage: "book.circle.fill") {
                        viewModel.toolbarDocsButtonTapped()
                    }
                }
                if let _ = URL(string: viewModel.termsUrl) {
                    Button("", systemImage: "info.circle.fill") {
                        viewModel.toolbarTermsButtonTapped()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.shouldShowDocsWebBrowser) {
            if let docsUrl = URL(string: viewModel.docsUrl) {
                let sf = SafariView(url: docsUrl)
                if #available(iOS 16.4, *) {
                    sf.presentationBackground(.thickMaterial)
                }
            }
        }
        .sheet(isPresented: $viewModel.shouldShowTermsWebBrowser) {
            if let termsUrl = URL(string: viewModel.termsUrl) {
                let sf = SafariView(url: termsUrl)
                if #available(iOS 16.4, *) {
                    sf.presentationBackground(.thickMaterial)
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
    let contentViewModel = ContentViewModel(currenciesFileName: "supported_currencies")
    ExchangeRatesView(viewModel: ExchangeRatesViewModel(webService: ERWebService()))
        .task {
            await contentViewModel.populateCurrencies()
        }
        .environmentObject(contentViewModel.currencyList)
}
