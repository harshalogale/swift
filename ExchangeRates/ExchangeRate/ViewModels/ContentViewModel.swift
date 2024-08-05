//
//  ContentViewModel.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import Foundation

/// Holds the details of a supported currency.
struct Currency: Codable, Hashable, Identifiable, Comparable {
    var id: String {
        currencyCode
    }
    
    var currencyCode: String
    var currencyName: String
    var country: String

    static func < (lhs: Currency, rhs: Currency) -> Bool {
        lhs.currencyCode == rhs.currencyCode
    }
}

/// Holds the list of supported currencies.
class CurrencyList: ObservableObject {
    var currencies: [Currency] = [] {
        didSet {
            print(Self.self, "currencies didSet")
            dictionary.removeAll()
            currencies.forEach {
                dictionary[$0.currencyCode] = $0
            }
        }
    }
    private var dictionary: Dictionary<String, Currency> = [:]

    subscript(currencyCode: String) -> Currency? {
        get {
            dictionary[currencyCode]
        }
    }
}

/// Powers the Content view.
@MainActor
final class ContentViewModel: ObservableObject {
    private var currenciesFileName: String
    @Published var currencyList = CurrencyList()
    
    init(currenciesFileName: String) {
        self.currenciesFileName = currenciesFileName
    }
    
    func populateCurrencies() async {
        guard
            let url = Bundle.main.url(forResource: currenciesFileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let currencies = try? JSONDecoder().decode([Currency].self, from: data)
        else {
            return
        }
        currencyList.currencies = currencies.sorted()
    }
}
