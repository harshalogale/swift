//
//  SpotifyRequestHandler.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import Foundation


/// A helper class to communicate with Spotify Web API. 
class SpotifyWebRequestHandler: NSObject {
    
    /// Enumeration of search types supported by Spotify Web API
    enum SpotifySearchType : Int {
        case album = 0
        case artist
        case playlist
        case track
    }
    
    static let SPOTIFY_API_URL = "https://api.spotify.com/v1/"
    
    static let DEFAULT_SEARCH_RESULT_OFFSET = 0
    static let DEFAULT_SEARCH_RESULT_LIMIT = 10
    
    /// Helper method to search for given keyword using Spotify web services, uses default
    static func search(keyword:String, searchType:SpotifySearchType, completionHandler: @escaping ([SPSearchResult]?) -> Swift.Void) {
        search(keyword: keyword, searchType: searchType, offset: DEFAULT_SEARCH_RESULT_OFFSET, limit: DEFAULT_SEARCH_RESULT_LIMIT, completionHandler: completionHandler)
    }
    
    /// Helper method that searches given keyword using Spotify web services and calls the completion handler when finished.
    static func search(keyword:String, searchType:SpotifySearchType, offset:Int, limit:Int, completionHandler: @escaping ([SPSearchResult]?) -> Swift.Void) {
        let searchUrl = generateSearchUrl(for: keyword, type: searchType, offset: offset, limit: limit)
        
        NetworkRequestHandler.get(url: searchUrl, allowCached: false) { (data, response, error) in
            var result : [SPSearchResult]? = nil
            
            if let jsonData = data {
                result = SPSearchResult.parseData(jsonData)
            }
            
            completionHandler(result)
        }
    }
    
    /// Generates Spotify Search Web API request url for the given keyword, media type, offset and limit
    static func generateSearchUrl(for keyword:String, type searchType:SpotifySearchType, offset: Int, limit:Int) -> String {
        // url encode the keyword string
        let searchString = keyword.stringByAddingPercentEncodingForRFC3986()!
        let spotifySearchUrl = SPOTIFY_API_URL + "search?query=\(searchString)&type=\(searchType)&offset=\(offset)&limit=\(limit)"
        
        return spotifySearchUrl
    }
    
    /// Generates Spotify Search Web API request url for the given keyword, media type and defaults to offset 0 and limit 10
    static func generateSearchUrl(for keyword:String, type searchType:SpotifySearchType) -> String {
        return generateSearchUrl(for: keyword, type: searchType, offset: 0, limit: 10)
    }
    
    /// Helper method to fetch the next page of the search results.
    static func getNextPage(url:String, completionHandler: @escaping ([SPSearchResult]?) -> Swift.Void) {
        NetworkRequestHandler.get(url: url, allowCached: false) { (data, response, error) in
            var result : [SPSearchResult]? = nil
            
            if let jsonData = data {
                result = SPSearchResult.parseData(jsonData)
            }
            
            completionHandler(result)
        }
    }
}

extension String {
    /// Helper method for percent encoding a string
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-_~"
        let allowed = CharacterSet.alphanumerics.union(CharacterSet.init(charactersIn: unreserved))
        return addingPercentEncoding(withAllowedCharacters: allowed)
    }
}

