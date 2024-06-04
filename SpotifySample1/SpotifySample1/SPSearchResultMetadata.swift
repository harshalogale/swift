//
//  SPSearchResultMetadata.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import Foundation

/// A structure to hold Spotify search results metadata
struct SPSearchResultMetadata {
    var type : String = ""
    var href : String = ""
    var limit : Int = 0
    var next : String? = ""
    var offset : Int = 0
    var total : Int = 0
    
    /// Parses Spotify search data dictionary representation and creates SPSearchResultMetadata objects.
    ///
    /// - Parameters:
    ///   - dict: dictionary representation of Spotify search results
    ///
    /// - Returns: an SPSearchResultMetadata object
    static func parse (dictionary dict : [String:Any]) -> SPSearchResultMetadata {
        var meta = SPSearchResultMetadata()
        
        if let limit = dict["limit"] as? Int {
            meta.limit = limit
        }
        if let next = dict["next"] as? String {
            meta.next = next
        }
        if let offset = dict["offset"] as? Int {
            meta.offset = offset
        }
        if let total = dict["total"] as? Int {
            meta.total = total
        }
        if let href = dict["href"] as? String {
            meta.href = href
        }
        
        return meta
    }
}
