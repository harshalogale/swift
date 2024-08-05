//
//  ContentView.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import SwiftUI

struct ContentView: View {
    private var viewModel: ContentViewModel
    @StateObject private var conversionRateViewModel = ConversionRateViewModel(webService: ERWebService())
    @StateObject private var exchangeRatesViewModel = ExchangeRatesViewModel(webService: ERWebService())

    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                ConversionRateView(viewModel: conversionRateViewModel)
            }
            .tabItem {
                Label("Conversion Rate", systemImage: "arrow.forward")
            }
            .accessibilityLabel("Conversion Rate Tab")
            .accessibilityIdentifier("conversionRateTabItem")
            NavigationStack {
                ExchangeRatesView(viewModel: exchangeRatesViewModel)
            }
            .tabItem {
                Label("Exchange Rates", systemImage: "list.bullet.rectangle.portrait")
            }
            .accessibilityLabel("Exchange Rates Tab")
            .accessibilityIdentifier("exchangeRatesTabItem")
        }
        .task {
            await viewModel.populateCurrencies()
        }
        .environmentObject(viewModel.currencyList)
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(currenciesFileName: "supported_currencies"))
}
