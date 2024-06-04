//
//  SPAlbum.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import Foundation

/// A structure to hold Spotify album info
struct SPAlbum {
    var name : String = ""
    var id : String = ""
    var href : String = ""
    var images : [SPImage] = []
    var artists : String = ""
    
    /// Parses an array of dictionaries and creates an array of SPAlbum objects.
    ///
    /// - Parameters:
    ///   - arr: an array of dictionary represenatations of Spotify albums
    ///
    /// - Returns: an array of SPAlbum objects
    static func parse (dictionaries arr : [[String:Any]]?) -> [SPAlbum]? {
        guard let arrDict = arr else {
            return nil
        }
        
        var albums: [SPAlbum] = []
        
        for dict in arrDict {
            if let album = parse(dictionary: dict) {
                albums.append(album)
            }
        }
        
        return albums
    }
    
    /// Parses input dictionary and creates an SPAlbum object.
    ///
    /// - Parameters:
    ///   - dict: dictionary represenatation of a Spotify album
    ///
    /// - Returns: an SPAlbum object
    static func parse (dictionary dict: [String:Any]) -> SPAlbum? {
        guard let name = dict["name"] as? String else {
            return nil
        }
        
        print("album: \(dict)")
        
        var album = SPAlbum()
        
        album.name = name
        
        if let val = dict["id"] as? String {
            album.id = val
        }
        
        if let val = dict["href"] as? String {
            album.href = val
        }
        
        if let val = dict["images"] {
            if let arrImages = SPImage.parse(dictionaries: val as? [[String:Any]]) {
                album.images = arrImages
            }
        }
        
        if let val = dict["artists"] {
            if let arrArtists = SPArtist.parseNames(dictionaries: val as? [[String:Any]]) {
                album.artists = arrArtists.joined(separator: ", ")
            }
        }
        
        return album
    }
}
