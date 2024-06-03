//
//  Quake.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/23/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// A structure to hold GeoJSON based earthquake object info.
struct Quake {
    var identifier: String?
    var title: String?
    var type: String?
    var place: String?
    var code: String?
    var status: String?
    var magnitude: Double?
    var magnitudeType: String?
    var latitude: Double?
    var longitude: Double?
    var depth: Double?
    var datetime: TimeInterval?
    
    /// Parses an array of dictionaries and creates an array of Quake objects.
    ///
    /// - Parameters:
    ///   - arr: an array of dictionary represenatations of earthquakes
    ///
    /// - Returns: an array of Quake objects
    static func parse (dictionaries arr: [[String:Any]]?) -> [Quake]? {
        guard let arrDict = arr else {
            return nil
        }
        
        var quakes:[Quake] = []
        for dict in arrDict {
            if let quake = parse(dictionary: dict) {
                quakes.append(quake)
            }
        }
        
        return quakes
    }
    
    /// Parses input dictionary and creates an Quake object.
    ///
    /// - Parameters:
    ///   - dict: dictionary represenatation of USGS earthquake search result
    ///
    /// - Returns: an Quake object
    static func parse (dictionary dict: [String:Any]) -> Quake? {
        guard let quakeId = dict["id"] as? String, let geo = dict["geometry"] as? [String:Any], let props = dict["properties"] as? [String:Any], let type = dict["type"] as? String else {
            return nil
        }
        
        guard type == "Feature" else {
            return nil
        }
        
        var eq = Quake()
        
        eq.identifier = quakeId
        eq.title = props["title"] as? String
        eq.place = props["place"] as? String
        eq.magnitude = props["mag"] as? Double
        eq.magnitudeType = props["magType"] as? String
        eq.code = props["code"] as? String
        
        if let microsec = props["time"] as? TimeInterval {
            eq.datetime = microsec / 1000
        }
        
        eq.type = props["type"] as? String
        eq.status = props["status"] as? String
        
        let geoCoord = geo["coordinates"] as? [Any]
        eq.latitude = geoCoord?[1] as? Double
        eq.longitude = geoCoord?[0] as? Double
        eq.depth = geoCoord?[2] as? Double
        
        return eq
    }
}
