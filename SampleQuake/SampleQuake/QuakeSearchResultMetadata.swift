//
//  QuakeSearchResultMetadata.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/25/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// A structure to hold Earthquake search results metadata
struct QuakeSearchResultMetadata {
    var title: String?
    var api: String?
    var url: String?
    var total: Int?
    var status: Int?
    var generated: TimeInterval?
    
    /// Parses Earthquakes search data dictionary representation and creates QuakeSearchResultMetadata objects.
    ///
    /// - Parameters:
    ///   - dict: dictionary representation of Earthquakes search results
    ///
    /// - Returns: an QuakeSearchResultMetadata object
    static func parse (dictionary dict: [String:Any]) -> QuakeSearchResultMetadata? {
        var meta: QuakeSearchResultMetadata?
        
        if let title = dict["title"] as? String {
            meta = QuakeSearchResultMetadata()
            meta?.title = title
            
            if let val = dict["api"] as? String {
                meta?.api = val
            }
            
            if let val = dict["url"] as? String {
                meta?.url = val
            }
            
            if let val = dict["count"] as? Int {
                meta?.total = val
            }
            
            if let val = dict["status"] as? Int {
                meta?.status = val
            }
            
            if let microsec = dict["generated"] as? TimeInterval {
                meta?.generated = microsec / 1000
            }
        }
        
        return meta
    }
}
