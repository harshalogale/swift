//
//  ExchangeRateModels.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import Foundation

enum ResultType: String, Codable {
    case success
    case error
}

/// Currency exchange rates response model.
///
/// ```
/// {
///     "result": "success",
///     "documentation": "https://www.exchangerate-api.com/docs",
///     "terms_of_use": "https://www.exchangerate-api.com/terms",
///     "time_last_update_unix": 1585267200,
///     "time_last_update_utc": "Fri, 27 Mar 2020 00:00:00 +0000",
///     "time_next_update_unix": 1585353700,
///     "time_next_update_utc": "Sat, 28 Mar 2020 00:00:00 +0000",
///     "base_code": "USD",
///     "conversion_rates": {
///         "USD": 1,
///         "AUD": 1.4817,
///         "BGN": 1.7741,
///         "CAD": 1.3168,
///         "CHF": 0.9774,
///         "CNY": 6.9454,
///         "EGP": 15.7361,
///         "EUR": 0.9013,
///         "GBP": 0.7679,
///         "...": 7.8536,
///         "...": 1.3127,
///         "...": 7.4722, etc. etc.
///     }
/// }
/// ```
/// Error Response:
/// ```
/// {
///     "result": "error",
///     "error-type": "unknown-code"
/// }
/// ```
struct ExchangeRatesResponse: Decodable {
    let result: ResultType
    let documentationUrl: String
    let termsOfUseUrl: String
    let lastUpdate: TimeInterval
    let nextUpdate: TimeInterval
    let currencyCode: String
    let conversionRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case result
        case documentationUrl = "documentation"
        case termsOfUseUrl = "terms_of_use"
        case lastUpdate = "time_last_update_unix"
        case nextUpdate = "time_next_update_unix"
        case currencyCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}


/// 
///
///Response:
///```
///{
///    "result": "success",
///    "documentation": "https://www.exchangerate-api.com/docs",
///    "terms_of_use": "https://www.exchangerate-api.com/terms",
///    "time_last_update_unix": 1585267200,
///    "time_last_update_utc": "Fri, 27 Mar 2020 00:00:00 +0000",
///    "time_next_update_unix": 1585270800,
///    "time_next_update_utc": "Sat, 28 Mar 2020 01:00:00 +0000",
///    "base_code": "EUR",
///    "target_code": "GBP",
///    "conversion_rate": 0.8412
///}
///```
struct ConversionRateResponse: Codable {
    let result: ResultType
    let documentationUrl: String
    let termsOfUseUrl: String
    let lastUpdate: TimeInterval
    let nextUpdate: TimeInterval
    let fromCode: String
    let toCode: String
    let conversionRate: Double
    
    enum CodingKeys: String, CodingKey {
        case result
        case documentationUrl = "documentation"
        case termsOfUseUrl = "terms_of_use"
        case lastUpdate = "time_last_update_unix"
        case nextUpdate = "time_next_update_unix"
        case fromCode = "base_code"
        case toCode = "target_code"
        case conversionRate = "conversion_rate"
    }
}
