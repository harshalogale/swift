//
//  ConversionRateViewModelTests.swift
//  ExchangeRateTests
//
//  Created by Harshal Ogale
//

import Combine
import XCTest
@testable import ExchangeRate

final class ConversionRateViewModelTests: XCTestCase {
    private let webService = ERWebServicingMock()
    private var sut: ConversionRateViewModel!
    private let successResponse = Optional(ConversionRateResponse(result: ResultType.success,
                                                                  documentationUrl: "",
                                                                  termsOfUseUrl: "",
                                                                  lastUpdate: NSTimeIntervalSince1970,
                                                                  nextUpdate: NSTimeIntervalSince1970,
                                                                  fromCode: "ABC",
                                                                  toCode: "XYZ",
                                                                  conversionRate: 56.98))
    
    
    @MainActor override func setUp() {
        super.setUp()

        sut = ConversionRateViewModel(webService: webService)
    }
    
    func test_currencyCodeChanged_fetchesConversionRate() async {
        // setup
        await sut.setFromCode(newValue: "ABC")
        await sut.setToCode(newValue: "XYZ")
        webService.fetchConversionRateHandler = { from, to in
            XCTAssertEqual(from, "ABC")
            XCTAssertEqual(to, "XYZ")
            
            return Just(self.successResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        // given
        XCTAssertEqual(webService.fetchConversionRateCallCount, 0)
        
        // when
        await sut.currencyCodeChanged()
        
        // then
        XCTAssertEqual(webService.fetchConversionRateCallCount, 1)
    }

    func test_swapCurrenciesButtonTapped_swapsFromAndToCurrencyCodes() async {
        // setup
        await sut.setFromCode(newValue: "ABC")
        await sut.setToCode(newValue: "XYZ")
        var from = await sut.fromCode
        var to = await sut.toCode
        
        // given
        XCTAssertEqual(from, "ABC")
        XCTAssertEqual(to, "XYZ")
        
        // when
        await sut.swapCurrenciesButtonTapped()
        
        // then
        from = await sut.fromCode
        to = await sut.toCode
        XCTAssertEqual(from, "XYZ")
        XCTAssertEqual(to, "ABC")
    }
}
