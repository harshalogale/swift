//
//  SPSearchResultTests.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import XCTest
@testable import SpotifySample1

final class SPSearchResultTests: XCTestCase {

    func testParseJson() {
        let jsonString = "{\"albums\" : {" +
            "\"href\" : \"https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=0&limit=1\"," +
            "\"items\" : [ {" +
            "\"album_type\" : \"album\"," +
            "\"artists\" : [ {" +
            "\"external_urls\" : {" +
            "\"spotify\" : \"https://open.spotify.com/artist/4S9EykWXhStSc15wEx8QFK\"" +
            "}," +
            "\"href\" : \"https://api.spotify.com/v1/artists/4S9EykWXhStSc15wEx8QFK\"," +
            "\"id\" : \"4S9EykWXhStSc15wEx8QFK\"," +
            "\"name\" : \"Céline Dion\"," +
            "\"type\" : \"artist\"," +
            "\"uri\" : \"spotify:artist:4S9EykWXhStSc15wEx8QFK\"" +
            "} ]," +
            "\"available_markets\" : [ \"US\" ]," +
            "\"external_urls\" : {" +
            "\"spotify\" : \"https://open.spotify.com/album/4Weiw9hd6IyxyjRyeDp3dF\"" +
            "}," +
            "\"href\" : \"https://api.spotify.com/v1/albums/4Weiw9hd6IyxyjRyeDp3dF\"," +
            "\"id\" : \"4Weiw9hd6IyxyjRyeDp3dF\"," +
            "\"images\" : [ {" +
            "\"height\" : 636," +
            "\"url\" : \"https://i.scdn.co/image/18e9a081d47245758507a5273bfd77453299d5f8\"," +
            "\"width\" : 640" +
            "}, {" +
            "\"height\" : 298," +
            "\"url\" : \"https://i.scdn.co/image/6c83428e3b3f471be0726b1afeba0eb4ccbd455e\"," +
            "\"width\" : 300" +
            "}, {" +
            "\"height\" : 64," +
            "\"url\" : \"https://i.scdn.co/image/60540a7b120aa0c30d764cbb318fef4c8a19600a\"," +
            "\"width\" : 64" +
            "} ]," +
            "\"name\" : \"The Essential Celine Dion\"," +
            "\"type\" : \"album\"," +
            "\"uri\" : \"spotify:album:4Weiw9hd6IyxyjRyeDp3dF\"" +
            "} ]," +
            "\"limit\" : 1," +
            "\"next\" : \"https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=1&limit=1\"," +
            "\"offset\" : 0," +
            "\"previous\" : null," +
            "\"total\" : 650}}"
        
        let jsonData = jsonString.data(using: String.Encoding.utf8)!
        
        let searchResults = SPSearchResult.parseData(jsonData)
        
        XCTAssertEqual(searchResults.count, 1)
        
        // check items
        XCTAssertEqual(searchResults[0].items.count, 1)
        XCTAssertEqual(searchResults[0].items[0].name, "The Essential Celine Dion")
        XCTAssertEqual(searchResults[0].items[0].href, "https://api.spotify.com/v1/albums/4Weiw9hd6IyxyjRyeDp3dF")
        XCTAssertEqual(searchResults[0].items[0].id, "4Weiw9hd6IyxyjRyeDp3dF")
        XCTAssertEqual(searchResults[0].items[0].images.count, 3)
        XCTAssertEqual(searchResults[0].items[0].images[0].url, "https://i.scdn.co/image/18e9a081d47245758507a5273bfd77453299d5f8")
        XCTAssertEqual(searchResults[0].items[0].images[0].size, CGSize(width:640, height:636))
        XCTAssertEqual(searchResults[0].items[0].images[1].url, "https://i.scdn.co/image/6c83428e3b3f471be0726b1afeba0eb4ccbd455e")
        XCTAssertEqual(searchResults[0].items[0].images[1].size, CGSize(width:300, height:298))
        XCTAssertEqual(searchResults[0].items[0].images[2].url, "https://i.scdn.co/image/60540a7b120aa0c30d764cbb318fef4c8a19600a")
        XCTAssertEqual(searchResults[0].items[0].images[2].size, CGSize(width:64, height:64))
        
        // check metadata
        XCTAssertEqual(searchResults[0].metadata?.href, "https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=0&limit=1")
        XCTAssertEqual(searchResults[0].metadata?.next, "https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=1&limit=1")
        XCTAssertEqual(searchResults[0].metadata?.limit, 1)
        XCTAssertEqual(searchResults[0].metadata?.total, 650)
        XCTAssertEqual(searchResults[0].metadata?.offset, 0)
    }
    
}
