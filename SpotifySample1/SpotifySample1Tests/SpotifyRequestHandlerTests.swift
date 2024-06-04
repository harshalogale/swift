//
//  SpotifyRequestHandlerTests.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import XCTest
@testable import SpotifySample1

final class SpotifyRequestHandlerTests: XCTestCase {
    
    func testSearchAlbum() {
        // search albums for "a", offset 0, limit 1
        // result must contain 1 album item
        // then getNext should fetch offset 1, limit 1
        
        let exp = expectation(description: "search request completion handler called")
        
        SpotifyWebRequestHandler.search(keyword: "a", searchType: SpotifyWebRequestHandler.SpotifySearchType.album, offset:0, limit:1) { (searchResult) in
            if let resp = searchResult {
                if resp.count == 1 {
                    // check items
                    XCTAssertEqual(resp[0].items.count, 1)
                    XCTAssertFalse(resp[0].items[0].name.isEmpty)
                    XCTAssertFalse(resp[0].items[0].href.isEmpty)
                    XCTAssertFalse(resp[0].items[0].id.isEmpty)
                    
                    // check metadata
                    if let meta = resp[0].metadata {
                        XCTAssertEqual(meta.href, "https://api.spotify.com/v1/search?query=a&type=album&offset=0&limit=1")
                        if let nextPage = meta.next {
                            XCTAssertFalse(nextPage.isEmpty)
                        } else {
                            XCTFail("next page url should not have been nil")
                        }
                        XCTAssertEqual(meta.limit, 1)
                        XCTAssertGreaterThan(meta.total, 1)
                        XCTAssertEqual(meta.offset, 0)
                    } else {
                        XCTFail("invalid metadata value")
                    }
                } else {
                    XCTFail("search query response should not have been empty")
                }
            } else {
                XCTFail("search query response should not have been nil")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchInvalidAlbum() {
        // search albums for "iusd783uiewdskus9", offset 0, limit 1
        // result should contain 0 album items
        // result should contain next = null
        
        let exp = expectation(description: "search request completion handler called")
        
        SpotifyWebRequestHandler.search(keyword: "iusd783uiewdskus9", searchType: SpotifyWebRequestHandler.SpotifySearchType.album, offset:0, limit:1) { (searchResult) in
            if let resp = searchResult {
                if resp.count == 1 {
                    // check items
                    XCTAssertEqual(resp[0].items.count, 0)
                    
                    // check metadata
                    if let meta = resp[0].metadata {
                        XCTAssertEqual(meta.href, "https://api.spotify.com/v1/search?query=iusd783uiewdskus9&type=album&offset=0&limit=1")
                        if let _ = meta.next {
                            XCTFail("next page url should have been nil")
                        }
                        XCTAssertEqual(meta.limit, 1)
                        XCTAssertEqual(meta.total, 0)
                        XCTAssertEqual(meta.offset, 0)
                    } else {
                        XCTFail("invalid metadata value")
                    }
                } else {
                    XCTFail("search query response should not have been empty")
                }
            } else {
                XCTFail("search query response should not have been nil")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetNextPage() {
        let exp = expectation(description: "get next page request completion handler called")
        
        SpotifyWebRequestHandler.getNextPage(url: "https://api.spotify.com/v1/search?query=a&type=album&offset=1&limit=1") { (searchResult) in
            if let resp = searchResult {
                if resp.count > 0 {
                    // check items
                    XCTAssertEqual(resp[0].items.count, 1)
                    XCTAssertFalse(resp[0].items[0].name.isEmpty)
                    XCTAssertFalse(resp[0].items[0].href.isEmpty)
                    XCTAssertFalse(resp[0].items[0].id.isEmpty)
                    
                    // check metadata
                    if let meta = resp[0].metadata {
                        XCTAssertEqual(meta.href, "https://api.spotify.com/v1/search?query=a&type=album&offset=1&limit=1")
                        if let nextPage = meta.next {
                            XCTAssertEqual(nextPage, "https://api.spotify.com/v1/search?query=a&type=album&offset=2&limit=1")
                        } else {
                            XCTFail("next page url should not have been nil")
                        }
                        XCTAssertEqual(meta.limit, 1)
                        XCTAssertGreaterThan(meta.total, 1)
                        XCTAssertEqual(meta.offset, 1)
                    } else {
                        XCTFail("invalid metadata value")
                    }
                } else {
                    XCTFail("search query response should not have been empty")
                }
            } else {
                XCTFail("search query response should not have been nil")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchUrl() {
        // check for various keywords: "shakira", "Celine Dion", "&"
        
        var expected = "https://api.spotify.com/v1/search?query=shakira&type=album&offset=0&limit=10"
        var actual = SpotifyWebRequestHandler.generateSearchUrl(for: "shakira", type: SpotifyWebRequestHandler.SpotifySearchType.album)
        XCTAssertEqual(expected, actual)
        
        expected = "https://api.spotify.com/v1/search?query=Celine%20Dion&type=album&offset=0&limit=10"
        actual = SpotifyWebRequestHandler.generateSearchUrl(for: "Celine Dion", type: SpotifyWebRequestHandler.SpotifySearchType.album)
        XCTAssertEqual(expected, actual)
        
        expected = "https://api.spotify.com/v1/search?query=%26&type=album&offset=5&limit=3"
        actual = SpotifyWebRequestHandler.generateSearchUrl(for: "&", type: SpotifyWebRequestHandler.SpotifySearchType.album, offset:5, limit:3)
        XCTAssertEqual(expected, actual)
    }
    
}
