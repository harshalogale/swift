//
//  ContentViewModel.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import Foundation

/// Holds the details of a supported currency.
struct SupportedCurrency: Codable, Hashable, Identifiable {
    var id: String {
        currencyCode
    }
    
    var currencyCode: String
    var currencyName: String
    var country: String
}

/// Holds the list of supported currencies.
class CurrencyList: ObservableObject {
    var supportedCurrencies: [SupportedCurrency] = []
}

/// Powers the Content view.
final class ContentViewModel: ObservableObject {
    private var supportedCurrenciesFileName: String
    @Published var currencyList = CurrencyList()
    
    init(supportedCurrenciesFileName: String) {
        self.supportedCurrenciesFileName = supportedCurrenciesFileName
    }
    
    func populateSupportedCurrencies() async {
        guard
            let url = Bundle.main.url(forResource: supportedCurrenciesFileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let supportedCurrencies = try? JSONDecoder().decode([SupportedCurrency].self, from: data)
        else {
            return
        }
        currencyList.supportedCurrencies = supportedCurrencies
    }
}
