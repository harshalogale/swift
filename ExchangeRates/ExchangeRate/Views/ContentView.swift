//
//  ContentView.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import SwiftUI

struct ContentView: View {
    private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    ConversionRateView(viewModel: ConversionRateViewModel(webService: ERWebService()))
                }
            }
            .tabItem {
                Label("Conversion Rate", systemImage: "arrow.forward")
            }
            NavigationStack {
                ScrollView {
                    ExchangeRatesView(viewModel: ExchangeRatesViewModel(webService: ERWebService()))
                }
            }
            .tabItem {
                Label("Exchange Rates", systemImage: "list.bullet.rectangle.portrait")
            }
        }
        .task {
            await viewModel.populateSupportedCurrencies()
        }
        .environmentObject(viewModel.currencyList)
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(supportedCurrenciesFileName: ""))
}
