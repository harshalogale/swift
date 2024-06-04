//
//  SPImage.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import Foundation
import UIKit

/// A structure to hold Spotify media item image info
struct SPImage {
    var size : CGSize = CGSize.zero
    var url : String = ""
    
    /// Parses an array of dictionaries and creates an array of SPImage objects.
    ///
    /// - Parameters:
    ///   - arr: an array of dictionary represenatations of Spotify media item images
    ///
    /// - Returns: an array of SPAlbum objects
    static func parse (dictionaries arr : [[String:Any]]?) -> [SPImage]? {
        guard let arrDict = arr else {
            return nil
        }
        
        var images = [SPImage]()
        
        for dict in arrDict {
            if let image = parse(dictionary: dict) {
                images.append(image)
            }
        }
        
        return images
    }
    
    static func parse (dictionary dict: [String:Any]) -> SPImage? {
        guard let imageUrl = dict["url"] as? String else {
            return nil
        }
        
        var image = SPImage()
        image.url = imageUrl
        
        if let imageWidth = dict["width"] as? Int,
           let imageHeight = dict["height"] as? Int {
            image.size = CGSize(width: imageWidth, height: imageHeight)
        }
        
        return image
    }
}
