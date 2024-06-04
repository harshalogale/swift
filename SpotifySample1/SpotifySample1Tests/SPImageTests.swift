//
//  SPImageTests.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import XCTest
@testable import SpotifySample1

final class SPImageTests: XCTestCase {
    
    func testParseSingleMissingUrl() {
        let dict = ["height" : 640,
                    "width" : 640 ] as [String : Any]
        
        if let _ = SPImage.parse(dictionary: dict) {
            XCTFail("SPImage creation should have failed due to missing image url")
        }
    }
    
    func testParseSingle() {
        let dict = ["height" : 640,
                        "url" : "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550",
                        "width" : 640 ] as [String : Any]
        
        if let image = SPImage.parse(dictionary: dict) {
            XCTAssertEqual(image.size, CGSize(width: 640, height: 640))
            XCTAssertEqual(image.url, "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550")
        } else {
            XCTFail("SPImage dictionary parsing failed")
        }
    }
    
    func testParseMultiple() {
        let arrDict = [ ["height" : 128, "url" : "https://i.scdn.co/image/8877665544332211", "width" : 128],
                        ["height" : 64, "url" : "https://i.scdn.co/image/789456123901", "width" : 64] ]
        
        if let images = SPImage.parse(dictionaries: arrDict) {
            XCTAssertEqual(images.count, 2)
            
            XCTAssertEqual(images[0].size, CGSize(width: 128, height: 128))
            XCTAssertEqual(images[0].url, "https://i.scdn.co/image/8877665544332211")
            
            XCTAssertEqual(images[1].size, CGSize(width: 64, height: 64))
            XCTAssertEqual(images[1].url, "https://i.scdn.co/image/789456123901")
        } else {
            XCTFail("SPImage dictionary array parsing failed")
        }
    }
    
}
