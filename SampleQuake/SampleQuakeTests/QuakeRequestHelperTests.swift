//
//  QuakeRequestHelperTests.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/27/17.
//  Copyright © 2017. All rights reserved.
//

import XCTest
@testable import SampleQuake

final class QuakeRequestHelperTests: XCTestCase {
    
    func testFetchQuakeList() {
        let exp = expectation(description: "fetch earthquakes completion handler called")
        
        QuakeRequestHelper.fetchQuakeList { searchResult in
            switch searchResult {
            case .success(let quake):
                print("fetch quake list: response = \(quake)")
                XCTAssertEqual(quake.items?.count, quake.metadata?.total)
                XCTAssertEqual(quake.metadata?.status, 200)
                XCTAssertNotNil(quake.metadata?.title)
                XCTAssertNotNil(quake.metadata?.api)
                XCTAssertNotNil(quake.metadata?.url)
                exp.fulfill()
            case .failure:
                break
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
