//
//  SPSearchResult.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import Foundation

/// A structure to hold Spotify search results
struct SPSearchResult {
    var metadata : SPSearchResultMetadata? = SPSearchResultMetadata()
    var items : [SPAlbum] = [SPAlbum]()
    
    /// Parses Spotify search JSON data and creates an array of SPSearchResult objects.
    ///
    /// - Parameters:
    ///   - jsonData: JSON data representation of Spotify search results
    ///
    /// - Returns: an array of SPSearchResult objects
    static func parseData (_ jsonData : Data) -> [SPSearchResult] {
        var searchResults = [SPSearchResult]()
        
        do {
            guard let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: [String: Any]] else {
                return []
            }
            
            for (key, value) in dict {
                var resultItem = SPSearchResult()
                
                resultItem.metadata = SPSearchResultMetadata.parse(dictionary: value)
                resultItem.metadata?.type = key
                
                let albumItems = value["items"] as? [[String:Any]]
                
                switch key {
                case "albums":
                    if let albums = SPAlbum.parse(dictionaries: albumItems) {
                        resultItem.items = albums
                    }
                default:
                    break
                }
                
                searchResults.append(resultItem)
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        return searchResults
    }
}
