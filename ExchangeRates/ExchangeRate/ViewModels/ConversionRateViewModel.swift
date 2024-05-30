//
//  ConversionRateViewModel.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import Combine
import Foundation
import SwiftUI

/// Powers the ConversionRate view.
@MainActor final class ConversionRateViewModel: ObservableObject {
    @Published var isSearching = false
    @Published var fromCode: String = ""
    @Published var toCode: String = ""
    @Published var fromCurrencyName: String = ""
    @Published var toCurrencyName: String = ""
    @Published var lastUpdateDate: String = ""
    @Published var nextUpdateDate: String = ""
    @Published var amountString = "1.00"
    @Published var convertedAmountString = "1.00"
    @Published var warningMessage: String? = nil {
        didSet {
            shouldShowWarningMessage = warningMessage != nil
        }
    }
    @Published var conversionRateString = ""
    @Published var shouldShowCurrencyInfo: Bool = false
    @Published var shouldShowConversionDetails: Bool = false
    @Published var shouldShowWarningMessage: Bool = false
    @Published var focusedField: Field?
    let docsUrl = "https://www.exchangerate-api.com/docs"
    let termsUrl = "https://www.exchangerate-api.com/terms"

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return formatter
    }()
    
    private func areCurrenciesSelected() -> Bool {
        !fromCode.isEmpty && !toCode.isEmpty && fromCode != toCode
    }
    
    private var amount: Double = 1.0
    private var conversionRate: Double = -1 {
        didSet {
            shouldShowConversionDetails = conversionRate > 0 && areCurrenciesSelected()
        }
    }
    private let webService: ERWebServicing
    
    private var cancellable: AnyCancellable?
    
    init(webService: ERWebServicing) {
        self.webService = webService
        focusedField = .fromCode
    }
    
    private func conversionRate(from: String, to: String) {
        conversionRate = -1
        cancellable = webService.fetchConversionRate(fromCurrency: from,
                                                     toCurrency: to)
        .replaceError(with: nil)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] response in
            guard let self else { return }
            guard let response else { return }
            conversionRate = response.conversionRate
            conversionRateString = self.conversionRate == -1 ? "" : String(conversionRate)
            if conversionRate > 0 {
                convertedAmountString = String(format: "%.5f", amount * conversionRate)
            }
            lastUpdateDate = dateFormatter.string(from: Date(timeIntervalSince1970: response.lastUpdate))
            nextUpdateDate = dateFormatter.string(from: Date(timeIntervalSince1970: response.nextUpdate))
        }
    }
    
    func amountInputChanged(editing: Bool) {
        amount = Double(amountString) ?? 0
        convertedAmountString = String(format: "%.5f", amount * conversionRate)
        focusedField = nil
    }
    
    func convertedAmountInputChanged(editing: Bool) {
        let convertedAmt = Double(convertedAmountString) ?? 0
        let calculatedBaseAmount = convertedAmt / conversionRate
        amountString = String(format: "%.5f", calculatedBaseAmount)
        focusedField = nil
    }
    
    func currencyCodeChanged() {
        shouldShowConversionDetails = false
        conversionRate(from: fromCode, to: toCode)
    }
    
    func swapCurrenciesButtonTapped() {
        let temp = fromCode
        fromCode = toCode
        toCode = temp
    }
    
    func toolbarDoneButtonTapped() {
        focusedField = nil
    }
    
    func onAppear() {
        fromCode = Locale.current.currency?.identifier ?? "INR"
        toCode = Locale.current.currency?.identifier ?? "INR"
    }
    
    func setFromCode(newValue: String) {
        fromCode = newValue
    }
    
    func setToCode(newValue: String) {
        toCode = newValue
    }
}
