//
//  SiriButton.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import IntentsUI

struct SiriButton: UIViewRepresentable {
    var intent: INIntent
    @Binding var shouldPresentSiriAdder: Bool
    @Binding var shouldPresentSiriEditor: Bool
    
    @Binding var addVoiceShortcutVC: INUIAddVoiceShortcutViewController?
    @Binding var editVoiceShortcutVC: INUIEditVoiceShortcutViewController?
    
    func makeCoordinator() -> SiriButton.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SiriButton>) -> INUIAddVoiceShortcutButton {
        print("button shortcut for intent: \(intent.identifier ?? "none"), \(intent.intentDescription ?? "none")")
        
        let btn = INUIAddVoiceShortcutButton(style: .automaticOutline)
        btn.delegate = context.coordinator
        btn.shortcut = INShortcut(intent: intent)
        btn.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return btn
    }
    
    func updateUIView(_ uiView: INUIAddVoiceShortcutButton, context: UIViewRepresentableContext<SiriButton>) {
        let btn:INUIAddVoiceShortcutButton = uiView
        print("updateUIView: \(btn.shortcut!.description)")
        print("updateUIView: \(btn.shortcut!.intent?.description ?? "no shortcut intent")")
    }
    
    class Coordinator: NSObject, INUIAddVoiceShortcutButtonDelegate {
        var parent: SiriButton
        
        init(_ siriButton: SiriButton) {
            self.parent = siriButton
        }
        
        // MARK: - INUIAddVoiceShortcutButtonDelegate
        
        func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
            parent.addVoiceShortcutVC = addVoiceShortcutViewController
            parent.shouldPresentSiriAdder = true
        }
        
        func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
            parent.editVoiceShortcutVC = editVoiceShortcutViewController
            parent.shouldPresentSiriEditor = true
        }
    }
}


struct SiriShortcutAdder: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var addVoiceShortcutViewController: INUIAddVoiceShortcutViewController!
    
    func makeCoordinator() -> SiriShortcutAdder.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SiriShortcutAdder>) -> INUIAddVoiceShortcutViewController {
        let vc = addVoiceShortcutViewController!
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiView: INUIAddVoiceShortcutViewController, context: UIViewControllerRepresentableContext<SiriShortcutAdder>) {
    }
    
    class Coordinator: NSObject, INUIAddVoiceShortcutViewControllerDelegate {
        var parent: SiriShortcutAdder
        
        init(_ siriShortcut: SiriShortcutAdder) {
            self.parent = siriShortcut
        }
        
        // MARK: - INUIAddVoiceShortcutViewControllerDelegate
        
        func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
            print(String(describing: voiceShortcut!))
            print("addVoiceShortcutVC: \(voiceShortcut!.shortcut.intent?.description ?? "no shortcut intent")")
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SiriShortcutEditor: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var editVoiceShortcutViewController: INUIEditVoiceShortcutViewController!
    
    func makeCoordinator() -> SiriShortcutEditor.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SiriShortcutEditor>) -> INUIEditVoiceShortcutViewController {
        
        let vc = editVoiceShortcutViewController!
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiView: INUIEditVoiceShortcutViewController, context: UIViewControllerRepresentableContext<SiriShortcutEditor>) {
        
    }
    
    class Coordinator: NSObject, INUIEditVoiceShortcutViewControllerDelegate {
        var parent: SiriShortcutEditor
        
        init(_ siriShortcut: SiriShortcutEditor) {
            self.parent = siriShortcut
        }
        
        // MARK: - INUIEditVoiceShortcutViewControllerDelegate
        
        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
