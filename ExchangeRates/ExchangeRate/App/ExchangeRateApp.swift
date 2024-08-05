//
//  ExchangeRateApp.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import SwiftUI

@main
struct ExchangeRateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(currenciesFileName: "supported_currencies"))
        }
    }
}
