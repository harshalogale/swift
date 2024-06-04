//
//  SPSearchResultMetadataTests.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import XCTest
@testable import SpotifySample1

final class SPSearchResultMetadataTests: XCTestCase {
    
    func testParseMetadata() {
        let dict = ["href" : "https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=0&limit=1",
            "items" : [ [
            "album_type" : "album",
            "artists" : [ [
            "external_urls" : [
            "spotify" : "https://open.spotify.com/artist/4S9EykWXhStSc15wEx8QFK"
            ],
            "href" : "https://api.spotify.com/v1/artists/4S9EykWXhStSc15wEx8QFK",
            "id" : "4S9EykWXhStSc15wEx8QFK",
            "name" : "Céline Dion",
            "type" : "artist",
            "uri" : "spotify:artist:4S9EykWXhStSc15wEx8QFK"
            ] ],
            "available_markets" : [ "US" ],
            "external_urls" : [
            "spotify" : "https://open.spotify.com/album/4Weiw9hd6IyxyjRyeDp3dF"
            ],
            "href" : "https://api.spotify.com/v1/albums/4Weiw9hd6IyxyjRyeDp3dF",
            "id" : "4Weiw9hd6IyxyjRyeDp3dF",
            "images" : [ [
            "height" : 636,
            "url" : "https://i.scdn.co/image/18e9a081d47245758507a5273bfd77453299d5f8",
            "width" : 640
            ], [
            "height" : 298,
            "url" : "https://i.scdn.co/image/6c83428e3b3f471be0726b1afeba0eb4ccbd455e",
            "width" : 300
            ], [
            "height" : 64,
            "url" : "https://i.scdn.co/image/60540a7b120aa0c30d764cbb318fef4c8a19600a",
            "width" : 64
            ] ],
            "name" : "The Essential Celine Dion",
            "type" : "album",
            "uri" : "spotify:album:4Weiw9hd6IyxyjRyeDp3dF"
            ] ],
            "limit" : 1,
            "next" : "https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=1&limit=1",
            "offset" : 0,
            "previous" : NSNull.init(),
            "total" : 650] as [String : Any]
        
        let meta = SPSearchResultMetadata.parse(dictionary: dict)
        XCTAssertEqual(meta.href, "https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=0&limit=1")
        XCTAssertEqual(meta.next, "https://api.spotify.com/v1/search?query=Celine+dion&type=album&offset=1&limit=1")
        XCTAssertEqual(meta.limit, 1)
        XCTAssertEqual(meta.total, 650)
        XCTAssertEqual(meta.offset, 0)
    }
    
}
