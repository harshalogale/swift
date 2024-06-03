//
//  QuakeRequestHelper.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/23/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

/// Helper class to fetch list of earthquakes from USGS
/// - [USGS Earthquake REST API](https://earthquake.usgs.gov/fdsnws/event/1/)
/// - [GeoJSON Summary Format](https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php)
final class QuakeRequestHelper {
    
    static let URL_USGS_DAILY_EARTHQUAKES_FEED = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
    
    /// Helper method that fetches the latest earthquake info
    static func fetchQuakeList(_ completionHandler: @escaping (Result<QuakeSearchResult, QuakeError>) -> Void) {
        let searchUrl = QuakeRequestHelper.URL_USGS_DAILY_EARTHQUAKES_FEED
        
        NetworkRequestHandler.get(searchUrl, allowCached: false) { (data, response, error) in
            if let _ = error {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let jsonData = data else {
                completionHandler(.failure(.networkError))
                return
            }
            
            QuakeSearchResult.parseData(jsonData) { (result) in
                switch result {
                case .failure(let quakeError):
                    completionHandler(.failure(quakeError))
                case .success(let quakeResult):
                    completionHandler(.success(quakeResult))
                }
            }
        }
    }
}
