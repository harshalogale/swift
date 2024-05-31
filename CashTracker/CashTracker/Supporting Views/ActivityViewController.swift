//
//  ActivityViewController.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import MessageUI

struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    
    var filesToShare: [Any]
    
    class Coordinator: NSObject {
        @Binding var isShowing: Bool
        var filesToShare: [Any]

        init(isShowing: Binding<Bool>,
             filesToShare: [Any]) {
            _isShowing = isShowing
            self.filesToShare = filesToShare
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           filesToShare: filesToShare)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        
        // Make the activityViewContoller which shows the share-view
        let activityVC = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            print("activityVC completed")
            self.isShowing = false
        }
        
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityViewController>) {
    }
    
    
}
