//
//  ExchangeRatesViewModelTests.swift
//  ExchangeRateTests
//
//  Created by Harshal Ogale
//

import Combine
import XCTest
@testable import ExchangeRate

final class ExchangeRatesViewModelTests: XCTestCase {
    private let webService = ERWebServicingMock()
    private var sut: ExchangeRatesViewModel!
    private let successResponse = Optional(ExchangeRatesResponse(result: ResultType.success,
                                                                 documentationUrl: "",
                                                                 termsOfUseUrl: "",
                                                                 lastUpdate: NSTimeIntervalSince1970,
                                                                 nextUpdate: NSTimeIntervalSince1970,
                                                                 currencyCode: "ABC",
                                                                 conversionRates: ["AAB" : 12.34,
                                                                                   "BBC" : 0.456]))
    
    @MainActor override func setUp() {
        super.setUp()

        sut = ExchangeRatesViewModel(webService: webService)
    }
    
    func test_init_fetchesExchangeRates() async {
        // then
        XCTAssertEqual(webService.fetchExchangeRatesCallCount, 1)
    }
    
    func test_currencySelected_fetchesExchangeRates() async {
        // setup
        webService.fetchExchangeRatesHandler = { currency in
            XCTAssertEqual(currency, "ABC")
            
            return Just(self.successResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        // given
        XCTAssertEqual(webService.fetchExchangeRatesCallCount, 1)
        
        // when
        await sut.currencySelected()
        
        // then
        XCTAssertEqual(webService.fetchExchangeRatesCallCount, 2)
    }

}
