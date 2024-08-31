//
//  IntentViewController.swift
//  CashTrackerIntentsUI
//
//  Created by Harshal Ogale
//

import IntentsUI
import CashTrackerShared

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.lightGray
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        
        if let cashIntent = interaction.intent as? AddCashIntent {
            let labelText: String
            let messageText: String
            
            if let resp = interaction.intentResponse as? AddCashIntentResponse, resp.code == AddCashIntentResponseCode.success {
                labelText = "Success"
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                // formatter.locale = NSLocale.currentLocale() // This is the default
                // In Swift 4, this ^ has been renamed to simply NSLocale.current
                
                messageText = "Added cash \(formatter.string(from: cashIntent.amount!.amount!)!) from \(cashIntent.title!)"
            } else {
                labelText = "Error"
                messageText = "Failed to add cash."
            }
            
            titleLabel.text = labelText
            messageTextView.text = messageText
        }
        
        completion(true, parameters, desiredSize)
    }
    
    var desiredSize: CGSize {
        extensionContext?.hostedViewMinimumAllowedSize ?? .zero
    }
    
}
