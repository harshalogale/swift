//
//  QuakeSearchResultTests.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/27/17.
//  Copyright © 2017. All rights reserved.
//

import XCTest
@testable import SampleQuake

final class QuakeSearchResultTests: XCTestCase {
    
    func testParseData() {
        let searchResult = "{\"type\":\"FeatureCollection\",\"metadata\":{\"generated\":1488746646000,\"url\":\"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson\",\"title\":\"USGS All Earthquakes, Past Day\",\"status\":200,\"api\":\"1.5.4\",\"count\":2},\"features\":[{\"type\":\"Feature\",\"properties\":{\"mag\":2.1,\"place\":\"11km W of Y, Alaska\",\"time\":1488746079539,\"updated\":1488746421999,\"tz\":-540,\"url\":\"https://earthquake.usgs.gov/earthquakes/eventpage/ak15442458\",\"detail\":\"https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ak15442458.geojson\",\"felt\":null,\"cdi\":null,\"mmi\":null,\"alert\":null,\"status\":\"automatic\",\"tsunami\":0,\"sig\":68,\"net\":\"ak\",\"code\":\"15442458\",\"ids\":\",ak15442458,\",\"sources\":\",ak,\",\"types\":\",geoserve,origin,\",\"nst\":null,\"dmin\":null,\"rms\":0.75,\"gap\":null,\"magType\":\"ml\",\"type\":\"earthquake\",\"title\":\"M 2.1 - 11km W of Y, Alaska\"},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-150.059,62.1421,41.9]},\"id\":\"ak15442458\"},{\"type\":\"Feature\",\"properties\":{\"mag\":6.33,\"place\":\"21km ENE of Little Lake, CA\",\"time\":1488745690170,\"updated\":1488745912756,\"tz\":-480,\"url\":\"https://earthquake.usgs.gov/earthquakes/eventpage/ci37819912\",\"detail\":\"https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ci37819912.geojson\",\"felt\":null,\"cdi\":null,\"mmi\":null,\"alert\":null,\"status\":\"manual\",\"tsunami\":1,\"sig\":27,\"net\":\"ci\",\"code\":\"37819912\",\"ids\":\",ci37819912,\",\"sources\":\",ci,\",\"types\":\",geoserve,nearby-cities,origin,phase-data,scitech-link,\",\"nst\":11,\"dmin\":0.04846,\"rms\":0.19,\"gap\":72,\"magType\":\"mb\",\"type\":\"earthquake\",\"title\":\"M 1.3 - 21km ENE of Little Lake, CA\"},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-117.7091667,36.042,-0.13]},\"id\":\"ci37819912\"}],\"bbox\":[-177.4662,-55.0791,-1.4,148.9734,65.8957,126.3]}"
        let searchJsonData = searchResult.data(using: String.Encoding.utf8)!
        QuakeSearchResult.parseData(searchJsonData) { result in
            switch result {
            case .success(let quake):
                // check metadata
                XCTAssertEqual(quake.metadata?.status, 200)
                XCTAssertEqual(quake.metadata?.total, 2)
                XCTAssertEqual(quake.metadata?.api, "1.5.4")
                XCTAssertEqual(quake.metadata?.url, "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")
                XCTAssertEqual(quake.metadata?.title, "USGS All Earthquakes, Past Day")
                XCTAssertEqual(quake.metadata?.generated, 1488746646)

                // check item count
                XCTAssertEqual(quake.items?.count, 2)

                // check first item
                XCTAssertEqual(quake.items?[0].code, "15442458")
                XCTAssertEqual(quake.items?[0].identifier, "ak15442458")
                XCTAssertEqual(quake.items?[0].latitude, 62.1421)
                XCTAssertEqual(quake.items?[0].longitude, -150.059)
                XCTAssertEqual(quake.items?[0].depth, 41.9)
                XCTAssertEqual(quake.items?[0].magnitude, 2.1)
                XCTAssertEqual(quake.items?[0].magnitudeType, "ml")
                XCTAssertEqual(quake.items?[0].place, "11km W of Y, Alaska")
                XCTAssertEqual(quake.items?[0].status, "automatic")
                XCTAssertEqual(quake.items?[0].type, "earthquake")
                XCTAssertEqual(quake.items?[0].datetime, 1488746079.539)
                XCTAssertEqual(quake.items?[0].title, "M 2.1 - 11km W of Y, Alaska")

                // check second item
                XCTAssertEqual(quake.items?[1].code, "37819912")
                XCTAssertEqual(quake.items?[1].identifier, "ci37819912")
                XCTAssertEqual(quake.items?[1].latitude, 36.042)
                XCTAssertEqual(quake.items?[1].longitude, -117.7091667)
                XCTAssertEqual(quake.items?[1].depth, -0.13)
                XCTAssertEqual(quake.items?[1].magnitude, 6.33)
                XCTAssertEqual(quake.items?[1].magnitudeType, "mb")
                XCTAssertEqual(quake.items?[1].place, "21km ENE of Little Lake, CA")
                XCTAssertEqual(quake.items?[1].status, "manual")
                XCTAssertEqual(quake.items?[1].type, "earthquake")
                XCTAssertEqual(quake.items?[1].datetime, 1488745690.170)
                XCTAssertEqual(quake.items?[1].title, "M 1.3 - 21km ENE of Little Lake, CA")

            case .failure(_):
                break
            }
        }
    }
}
