//
//  SPAlbumTests.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import XCTest
import UIKit
@testable import SpotifySample1

final class SPAlbumTests: XCTestCase {
    
    /*
     {
         "album_type" : "album",
         "artists" : [ {
         "external_urls" : {
         "spotify" : "https://open.spotify.com/artist/31W5EY0aAly4Qieq6OFu6I"
         },
         "href" : "https://api.spotify.com/v1/artists/31W5EY0aAly4Qieq6OFu6I",
         "id" : "31W5EY0aAly4Qieq6OFu6I",
         "name" : "A Boogie Wit da Hoodie",
         "type" : "artist",
         "uri" : "spotify:artist:31W5EY0aAly4Qieq6OFu6I"
         } ],
         
         "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "ID", "IE", "IS", "IT", "JP", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PL", "PT", "PY", "SE", "SG", "SK", "SV", "TR", "TW", "US", "UY" ],
         "external_urls" : {
         "spotify" : "https://open.spotify.com/album/2OQEAqShAl6SodrGhmYZ4Z"
         },
         "href" : "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z",
         "id" : "2OQEAqShAl6SodrGhmYZ4Z",
         "images" : [ {
         "height" : 640,
         "url" : "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550",
         "width" : 640
         }, {
         "height" : 300,
         "url" : "https://i.scdn.co/image/fa99f488ee247e6d7f09d16d906dc81250710156",
         "width" : 300
         }, {
         "height" : 64,
         "url" : "https://i.scdn.co/image/64172d15adfb104dc905f9facd0988d82f44f6aa",
         "width" : 64
         } ],
         "name" : "Artist",
         "type" : "album",
         "uri" : "spotify:album:2OQEAqShAl6SodrGhmYZ4Z"
     }
     */
    func testProperties() {
        var album = SPAlbum()
        
        album.name = "album1"
        album.id = "abcdefghij1234567890"
        album.href = "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z"
        
        var img64 = SPImage()
        img64.size = CGSize(width: 64, height: 64)
        img64.url = "https://i.scdn.co/image/64172d15adfb104dc905f9facd0988d82f44f6aa"
        
        var img300 = SPImage()
        img300.size = CGSize(width: 300, height: 300)
        img300.url = "https://i.scdn.co/image/fa99f488ee247e6d7f09d16d906dc81250710156"
        
        var img640 = SPImage()
        img640.size = CGSize(width: 640, height: 640)
        img640.url = "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550"
        
        album.images = [img64, img300, img640]
        
        XCTAssertEqual(album.name, "album1", "Album name should be what we assigned")
        XCTAssertEqual(album.id, "abcdefghij1234567890", "Album id should be what we assigned")
        XCTAssertEqual(album.href, "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z", "Album href should be what we assigned")
    }
    
    func testParseSingleNoName() {
        let dict = ["album_type" : "album",
                    "available_markets" : [ "AD", "AR", "AT", "AU", "US", "UY" ],
                    "href" : "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z",
                    "id" : "2OQEAqShAl6SodrGhmYZ4Z",
                    "images" : [ [
                        "height" : 640,
                        "url" : "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550",
                        "width" : 640
                        ] ],
                    "type" : "album",
                    "uri" : "spotify:album:2OQEAqShAl6SodrGhmYZ4Z"] as [String : Any]
        
        if let _ = SPAlbum.parse(dictionary: dict) {
            XCTFail("SPAlbum creation should have failed when name property is missing")
        }
    }
    
    func testParseSingle() {
        let dict = ["album_type" : "album",
            "available_markets" : [ "AD", "AR", "AT", "AU", "US", "UY" ],
            "href" : "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z",
            "id" : "2OQEAqShAl6SodrGhmYZ4Z",
            "images" : [ [
            "height" : 640,
            "url" : "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550",
            "width" : 640
            ] ],
            "name" : "album1",
            "type" : "album",
            "uri" : "spotify:album:2OQEAqShAl6SodrGhmYZ4Z"] as [String : Any]
        
        if let album = SPAlbum.parse(dictionary: dict) {
            XCTAssertEqual(album.name, "album1")
            XCTAssertEqual(album.id, "2OQEAqShAl6SodrGhmYZ4Z")
            XCTAssertEqual(album.href, "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z")
            XCTAssertEqual(album.images.count, 1)
            XCTAssertEqual(album.images[0].size, CGSize(width: 640, height: 640))
            XCTAssertEqual(album.images[0].url, "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550")
        } else {
            XCTFail("SPAlbum dictionary parsing failed")
        }
    }
    
    func testParseMultiple() {
        let arrDict = [ ["album_type" : "album",
                    "available_markets" : [ "AD", "AR", "AT", "AU", "US", "UY" ],
                    "href" : "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z",
                    "id" : "2OQEAqShAl6SodrGhmYZ4Z",
                    "images" : [ [
                        "height" : 640,
                        "url" : "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550",
                        "width" : 640
                        ] ],
                    "name" : "album1",
                    "type" : "album",
                    "uri" : "spotify:album:2OQEAqShAl6SodrGhmYZ4Z"],
                    ["album_type" : "album",
                        "available_markets" : [ "AD", "AR", "AT", "AU", "US", "UY" ],
                        "href" : "https://api.spotify.com/v1/albums/12345567890",
                        "id" : "12345567890",
                        "images" : [ [
                            "height" : 128,
                            "url" : "https://i.scdn.co/image/8877665544332211",
                            "width" : 128
                            ] ],
                        "name" : "album 123",
                        "type" : "album",
                        "uri" : "spotify:album:12345567890"] ]
        
        if let albums = SPAlbum.parse(dictionaries: arrDict) {
            XCTAssertEqual(albums.count, 2)
            
            XCTAssertEqual(albums[0].name, "album1")
            XCTAssertEqual(albums[0].id, "2OQEAqShAl6SodrGhmYZ4Z")
            XCTAssertEqual(albums[0].href, "https://api.spotify.com/v1/albums/2OQEAqShAl6SodrGhmYZ4Z")
            XCTAssertEqual(albums[0].images.count, 1)
            XCTAssertEqual(albums[0].images[0].size, CGSize(width: 640, height: 640))
            XCTAssertEqual(albums[0].images[0].url, "https://i.scdn.co/image/9ea8af46bc494b8309980169efdea578c9e1b550")
            
            XCTAssertEqual(albums[1].name, "album 123")
            XCTAssertEqual(albums[1].id, "12345567890")
            XCTAssertEqual(albums[1].href, "https://api.spotify.com/v1/albums/12345567890")
            XCTAssertEqual(albums[1].images.count, 1)
            XCTAssertEqual(albums[1].images[0].size, CGSize(width: 128, height: 128))
            XCTAssertEqual(albums[1].images[0].url, "https://i.scdn.co/image/8877665544332211")
        } else {
            XCTFail("SPAlbum dictionary array parsing failed")
        }
    }
    
}
