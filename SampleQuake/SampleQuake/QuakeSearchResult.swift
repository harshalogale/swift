//
//  QuakeSearchResult.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/24/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

enum QuakeError: Error {
    case networkError
    case parsingError
}

/// A structure to hold Earthquake search results
struct QuakeSearchResult {
    var metadata: QuakeSearchResultMetadata?
    var items: [Quake]?
    
    /// Parses USGS earthquake JSON data and creates a QuakeSearchResult object.
    ///
    /// - Parameters:
    ///   - jsonData: JSON data representation of USGS earthquake list results
    ///
    /// - Returns: a QuakeSearchResult object
    static func parseData (_ jsonData: Data, completion: @escaping (Result<QuakeSearchResult, QuakeError>) -> Void) {
        do {
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            if let dict = dict, let metaDict = dict["metadata"] as? [String:Any], let quakeDicts = dict["features"] as? [[String:Any]] {
                let meta = QuakeSearchResultMetadata.parse(dictionary: metaDict)
                
                let items = Quake.parse(dictionaries: quakeDicts)
                
                if let resultMeta = meta, let resultItems = items {
                    let result = QuakeSearchResult(metadata: resultMeta, items: resultItems)
                    completion(.success(result))
                } else {
                    completion(.failure(.parsingError))
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            completion(.failure(.networkError))
        }
    }
}
