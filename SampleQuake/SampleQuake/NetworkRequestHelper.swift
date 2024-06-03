//
//  NetworkRequestHelper.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/24/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/// A helper class to fire network requests.
final class NetworkRequestHandler: NSObject {
    
    /// Fires an HTTP GET request to the given url and then calls a completion handler code block.
    ///
    /// - Parameters:
    ///   - url: a url to fetch with the GET request
    ///   - allowCached: optionally use local cache
    ///   - completionHandler: a code block to be called when the method ends
    ///     - data: response data received from the GET request
    ///     - response: URLResponse received from the GET request
    ///     - error: error info received when the GET request fails
    static func get(_ url: String, allowCached: Bool, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        guard let targetUrl = URL(string: url) else {
            let userInfo: [String: AnyObject] =
                [
                    NSLocalizedDescriptionKey: NSLocalizedString("Invalid URL", comment: "Invalid URL") as AnyObject,
                    NSLocalizedFailureReasonErrorKey: NSLocalizedString("Invalid URL", comment: "Invalid URL") as AnyObject
            ]
            let err = NSError(domain: "SampleQuakeErrorDomain", code: 404, userInfo: userInfo)
            completionHandler(nil, nil, err)
            return
        }
        let cachePolicy = allowCached ? URLRequest.CachePolicy.returnCacheDataElseLoad : URLRequest.CachePolicy.reloadIgnoringCacheData
        let req = URLRequest(url: targetUrl, cachePolicy: cachePolicy)
        URLSession.shared.dataTask(with: req, completionHandler: completionHandler).resume()
    }
}
