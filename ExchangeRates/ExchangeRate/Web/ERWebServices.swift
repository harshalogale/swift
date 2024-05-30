//
//  ERWebServices.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import Foundation
import Combine

enum ERWebServiceError: Error {
    case networkRequestError
    case networkResponseError
}

/// @mockable
protocol ERWebServicing {
    func fetchExchangeRates(for currencyCode: String) -> AnyPublisher<ExchangeRatesResponse?, Error>
    func fetchConversionRate(fromCurrency fromCode: String,
                             toCurrency toCode: String) -> AnyPublisher<ConversionRateResponse?, Error>
}

/// Provides access to ExchangeRate API Web Services
struct ERWebService: ERWebServicing {
    private let urlPrefix = "https://v6.exchangerate-api.com/v6/YOUR-API-KEY"
    
    /// Returns the exchange rate from source currency to the target currency. Fires a web request to the ExchangeRate API.
    ///
    /// Query Format:
    /// ```https://v6.exchangerate-api.com/v6/YOUR-API-KEY/pair/EUR/GBP```
    /// 
    /// - Parameters:
    ///   - fromCode: source currency code as per ISO 4217
    ///   - toCode: target currency code as per ISO 4217
    /// - Returns: ConversionRateResponse
    func fetchConversionRate(fromCurrency fromCode: String,
                             toCurrency toCode: String) -> AnyPublisher<ConversionRateResponse?, Error> {
        let urlString = urlPrefix + "/pair/\(fromCode)/\(toCode)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ConversionRateResponse?.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    /// Returns the list of exchange rates to all currencies from the given currency. Fires a web request to the ExchangeRate API.
    ///
    /// Query Format:
    /// ```https://v6.exchangerate-api.com/v6/YOUR-API-KEY/latest/INR```
    /// 
    /// - Parameters:
    ///   - currencyCode: source currency code as per ISO 4217
    /// - Returns: ExchangeRatesResponse
    func fetchExchangeRates(for currencyCode: String) -> AnyPublisher<ExchangeRatesResponse?, Error> {
        let urlString = urlPrefix + "/latest/\(currencyCode)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ExchangeRatesResponse?.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
