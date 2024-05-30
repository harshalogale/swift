//
//  WebBrowserView.swift
//  ExchangeRate
//
//  Created by Harshal Ogale
//

import SafariServices
import SwiftUI

/// A wrapper for SFSafariWebViewController that allows a web page to be displayed in-app.
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {
        // Update the view controller when necessary
    }
}
