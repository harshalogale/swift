//
//  SPArtist.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import Foundation

/// A structure to hold Spotify album info
struct SPArtist {
    var name : String = ""
    var id : String = ""
    var href : String = ""
    
    /// Parses an array of dictionaries and creates an array of String objects with artist names.
    ///
    /// - Parameters:
    ///   - arr: an array of dictionary represenatations of Spotify artists
    ///
    /// - Returns: an array of String objects
    static func parseNames (dictionaries arr : [[String:Any]]?) -> [String]? {
        guard let arrDict = arr else {
            return nil
        }
        
        var artists = [String]()
        
        for dict in arrDict {
            if let artist = parseName(dictionary: dict) {
                artists.append(artist)
            }
        }
        
        return artists
    }
    
    /// Parses input dictionary and creates a String object.
    ///
    /// - Parameters:
    ///   - dict: dictionary represenatation of a Spotify artist
    ///
    /// - Returns: a String object
    static func parseName (dictionary dict: [String:Any]) -> String? {
        dict["name"] as? String
    }
}
