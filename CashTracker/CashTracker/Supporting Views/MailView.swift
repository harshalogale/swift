//
//  MailView.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    var exp: Data?
    var cash: Data?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        var dataExp: Data?
        var dataCash: Data?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>,
             exp: Data?,
             cash: Data?) {
            _isShowing = isShowing
            _result = result
            self.dataExp = exp
            self.dataCash = cash
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
        
        func configuredMailComposeViewController() -> MFMailComposeViewController {
            let emailController = MFMailComposeViewController()
            emailController.mailComposeDelegate = self
            emailController.setSubject("CashTracker: Expense/Cash Report CSV")
            emailController.setMessageBody("CashTracker: Expense/Cash Report CSV", isHTML: false)
            
            // Attaching the report .CSV files to the email.
            if nil != dataExp {
                emailController.addAttachmentData(dataExp!, mimeType: "text/csv", fileName: "reportExpenses.csv")
            }
            if nil != dataCash {
                emailController.addAttachmentData(dataCash!, mimeType: "text/csv", fileName: "reportCash.csv")
            }
            return emailController
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result,
                           exp: exp,
                           cash: cash)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
    
    
}
