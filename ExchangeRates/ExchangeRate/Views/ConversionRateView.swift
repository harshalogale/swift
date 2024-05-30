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
                HStack {
                    HStack {
                        Text("From:")
                            .font(.title3)
                            .bold()
                        let currencyPicker = Picker("From Currency", selection: $viewModel.fromCode) {
                            ForEach(currencyList.supportedCurrencies) { currency in
                                Text(currency.currencyCode)
                            }
                        }
                            .pickerStyle(MenuPickerStyle())
                            .font(.title)
                            .bold()
                            .padding()
                        if #available(iOS 17.0, *) {
                            currencyPicker
                                .onChange(of: viewModel.fromCode) {
                                    viewModel.currencyCodeChanged()
                                }
                        } else {
                            currencyPicker
                                .onChange(of: viewModel.fromCode) { _ in
                                    viewModel.currencyCodeChanged()
                                }
                        }
                    }
                    Spacer()
                    Button("", systemImage: "arrow.left.arrow.right") {
                        viewModel.swapCurrenciesButtonTapped()
                    }
                    Spacer()
                    HStack {
                        Text("To:")
                            .font(.title3)
                            .bold()
                        let currencyPicker = Picker("To Currency", selection: $viewModel.toCode) {
                            ForEach(currencyList.supportedCurrencies) { currency in
                                Text(currency.currencyCode)
                                    .font(.title)
                                    .bold()
                            }
                        }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                        if #available(iOS 17.0, *) {
                            currencyPicker
                                .onChange(of: viewModel.toCode) {
                                    viewModel.currencyCodeChanged()
                                }
                        } else {
                            currencyPicker
                                .onChange(of: viewModel.toCode) { _ in
                                    viewModel.currencyCodeChanged()
                                }
                        }
                    }
                }
                .padding(.horizontal)
                if viewModel.shouldShowConversionDetails {
                    VStack {
                        HStack {
                            Text("Last update date:")
                                .grayscale(0.4)
                                .font(.caption)
                                .bold()
                                .padding(.trailing)
                            Text(viewModel.lastUpdateDate)
                                .font(.caption)
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            Text("Next update date:")
                                .font(.caption)
                                .bold()
                                .padding(.trailing)
                            Text(viewModel.nextUpdateDate)
                                .font(.caption)
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .foregroundStyle(.gray)
                }
            }
            if viewModel.shouldShowConversionDetails {
                VStack {
                    HStack {
                        Text("Conversion Rate")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Text(viewModel.conversionRateString)
                            .font(.title)
                            .monospaced()
                            .bold()
                            .padding(.horizontal)
                    }
                    VStack {
                        VStack {
                            HStack {
                                Text("From \(viewModel.fromCode) Amount")
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
                                Text("To \(viewModel.toCode) Amount")
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
                if let docsUrl = URL(string: viewModel.docsUrl) {
                    NavigationLink(destination: SafariView(url: docsUrl)) {
                        Image(systemName: "book.circle.fill")
                    }
                }
                if let termsUrl = URL(string: viewModel.termsUrl) {
                    NavigationLink(destination: SafariView(url: termsUrl)) {
                        Image(systemName: "info.circle.fill")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    viewModel.toolbarDoneButtonTapped()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationTitle("Conversion Rate")
    }
}

#Preview {
    ConversionRateView(viewModel: ConversionRateViewModel(webService: ERWebService()))
}
