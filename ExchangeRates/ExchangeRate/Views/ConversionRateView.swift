//
//  ConversionRateView.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import Foundation
import SwiftUI

enum Field: Int, CaseIterable {
    case fromCode, toCode, fromAmount, toAmount
}

/// A view to let the user select a source currency code and a target currency code and displays the conversion rate. Allows the user to swap the source and target currencies. Allows the user to enter amount
struct ConversionRateView: View {
    @EnvironmentObject var currencyList: CurrencyList
    @ObservedObject private var viewModel: ConversionRateViewModel
    @FocusState private var focusedField: Field?
    
    init(viewModel: ConversionRateViewModel) {
        self.viewModel = viewModel
    }
    
    private var amount: Double {
        Double(viewModel.amountString) ?? 1.0
    }

    private var convertedAmount: Double {
        Double(viewModel.convertedAmountString) ?? 1.0
    }
    
    var body: some View {
        VStack {
            VStack {
                CurrencySelectorView(viewModel: viewModel)
                .padding(.horizontal)
            }
            ScrollView {
                if viewModel.shouldShowConversionDetails {
                    VStack {
                        HStack {
                            Text("Last update date:")
                                .grayscale(0.4)
                                .font(.caption2)
                                .monospaced()
                                .padding(.trailing)
                            Text(viewModel.lastUpdateDate)
                                .font(.caption2)
                                .monospaced()
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            Text("Next update date:")
                                .font(.caption2)
                                .monospaced()
                                .padding(.trailing)
                            Text(viewModel.nextUpdateDate)
                                .font(.caption2)
                                .monospaced()
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .foregroundStyle(.gray)
                }

                if viewModel.shouldShowConversionDetails {
                    VStack {
                        VStack {
                            HStack {
                                Text("Conversion Rate")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)
                                Spacer()
                            }
                            HStack {
                                Text(viewModel.conversionRateString)
                                    .font(.title)
                                    .monospaced()
                                    .bold()
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                        VStack {
                            VStack {
                                HStack {
                                    Text("From \(viewModel.fromCode) Amount:")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    TextField("", text: $viewModel.amountString, onEditingChanged: { editing in
                                        viewModel.amountInputChanged(editing: editing)
                                    })
                                    .font(.title3)
                                    .monospaced()
                                    .keyboardType(.decimalPad)
                                    .scrollDismissesKeyboard(.immediately)
                                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                                    .cornerRadius(5)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .fromAmount)
                                    .onChange(of: viewModel.focusedField) {
                                        focusedField = $0
                                    }
                                    .onChange(of: focusedField) {
                                        viewModel.focusedField = $0
                                    }
                                }
                            }
                            .padding()
                            VStack {
                                HStack {
                                    Text("To \(viewModel.toCode) Amount:")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                HStack {
                                    TextField("",
                                              text: $viewModel.convertedAmountString, onEditingChanged: { editing in
                                        viewModel.convertedAmountInputChanged(editing: editing)
                                    })
                                    .font(.title3)
                                    .monospaced()
                                    .keyboardType(.decimalPad)
                                    .scrollDismissesKeyboard(.immediately)
                                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                                    .cornerRadius(5)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .toAmount)
                                    .onChange(of: viewModel.focusedField) {
                                        focusedField = $0
                                    }
                                    .onChange(of: focusedField) {
                                        viewModel.focusedField = $0
                                    }
                                }
                            }
                            .padding()
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2.0)
                        }
                    }
                    .padding()
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            if viewModel.shouldShowWarningMessage {
                if let warningMessage = viewModel.warningMessage {
                    Text(warningMessage)
                        .font(.title).bold().multilineTextAlignment(.center)
                        .padding(.vertical, 30)
                        .tint(.gray)
                }
            }
            Spacer()
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
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    viewModel.toolbarDoneButtonTapped()
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
        .onAppear {
            viewModel.onAppear()
        }
        .navigationTitle("Conversion Rate")
    }
}

struct CurrencySelectorView: View {
    @ObservedObject private var viewModel: ConversionRateViewModel
    @EnvironmentObject var currencyList: CurrencyList

    init(viewModel: ConversionRateViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                HStack(alignment: .firstTextBaseline) {
                    VStack {
                        (Text("From") + Text(":"))
                            .font(.title3)
                            .bold()
                    }
                    VStack {
                        if #available(iOS 18.0, *) {
                            Picker("", selection: $viewModel.fromCode) {
                                ForEach(currencyList.currencies) { currency in
                                    Text(currency.currencyCode) + Text(": ") + Text(currency.currencyName)
                                }
                            } currentValueLabel: {
                                if let _ = currencyList[viewModel.fromCode] {
                                    Text(viewModel.fromCode)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                            .onChange(of: viewModel.fromCode) { _ in
                                viewModel.currencyCodeChanged()
                            }
                        } else {
                            Picker("", selection: $viewModel.fromCode) {
                                ForEach(currencyList.currencies) { currency in
                                    Text(currency.currencyCode)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                            .onChange(of: viewModel.fromCode) { _ in
                                viewModel.currencyCodeChanged()
                            }
                        }
                        if let currency = currencyList[viewModel.fromCode] {
                            Text(currency.currencyName)
                                .font(.caption)
                        }
                    }
                }
                Spacer()
                Button("", systemImage: "arrow.left.arrow.right") {
                    viewModel.swapCurrenciesButtonTapped()
                }
                Spacer()
                HStack(alignment: .firstTextBaseline) {
                    VStack {
                        (Text("To") + Text(":"))
                            .font(.title3)
                            .bold()
                    }
                    VStack {
                        if #available(iOS 18.0, *) {
                            Picker("", selection: $viewModel.toCode) {
                                ForEach(currencyList.currencies) { currency in
                                    Text(currency.currencyCode) + Text(": ") + Text(currency.currencyName)
                                }
                            } currentValueLabel: {
                                if let _ = currencyList[viewModel.toCode] {
                                    Text(viewModel.toCode)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                            .onChange(of: viewModel.toCode) { _ in
                                viewModel.currencyCodeChanged()
                            }
                        } else {
                            Picker("", selection: $viewModel.toCode) {
                                ForEach(currencyList.currencies) { currency in
                                    Text(currency.currencyCode)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                            .onChange(of: viewModel.toCode) { _ in
                                viewModel.currencyCodeChanged()
                            }
                        }
                        if let currency = currencyList[viewModel.toCode] {
                            Text(currency.currencyName)
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let contentViewModel = ContentViewModel(currenciesFileName: "supported_currencies")
    ConversionRateView(viewModel: ConversionRateViewModel(webService: ERWebService()))
        .task {
            await contentViewModel.populateCurrencies()
        }
        .environmentObject(contentViewModel.currencyList)
}
