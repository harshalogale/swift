//
//  ExchangeRatesViewModel.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import SwiftUI
import Combine


/// Powers the ExchangeRates view.
@MainActor final class ExchangeRatesViewModel: ObservableObject {
    @Published var exchangeRates: [String: Double] = [:]
    @Published var lastUpdate: TimeInterval?
    @Published var nextUpdate: TimeInterval?
    @Published var currencyCode: String = Locale.current.currency?.identifier ?? "USD"
    @Published var shouldShowDocsWebBrowser: Bool = false
    @Published var shouldShowTermsWebBrowser: Bool = false
    let docsUrl = "https://www.exchangerate-api.com/docs"
    let termsUrl = "https://www.exchangerate-api.com/terms"

    private var cancellable: AnyCancellable?
    private let webService: ERWebServicing

    init(webService: ERWebServicing) {
        self.webService = webService
        fetchExchangeRates(for: currencyCode)
    }
    
    /// Fetches a list of currency exchange rates for all other currencies from the source currency code.
    /// - Parameter currencyCode: source currency code as per ISO 4217
    private func fetchExchangeRates(for currencyCode: String) {
        cancellable = webService.fetchExchangeRates(for: currencyCode)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.exchangeRates = response?.conversionRates ?? [:]
                self?.exchangeRates = response?.conversionRates ?? [:]
            }
    }

    /// Fetches exchange rates list for the newly selected currency code.
    func currencySelected() {
        fetchExchangeRates(for: currencyCode)
    }

    func toolbarDocsButtonTapped() {
        shouldShowDocsWebBrowser = true
    }

    func toolbarTermsButtonTapped() {
        shouldShowTermsWebBrowser = true
    }
}
