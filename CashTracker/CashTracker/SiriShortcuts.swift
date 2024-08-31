//
//  SiriShortcuts.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import IntentsUI
import CashTrackerShared

struct SiriShortcuts: View {
    
    @State private var showingSiriAdder1: Bool
    @State private var showingSiriEditor1: Bool
    @State private var addVoiceShortcutVC1: INUIAddVoiceShortcutViewController?
    @State private var editVoiceShortcutVC1: INUIEditVoiceShortcutViewController?
    
    @State private var showingSiriAdder2: Bool
    @State private var showingSiriEditor2: Bool
    @State private var addVoiceShortcutVC2: INUIAddVoiceShortcutViewController?
    @State private var editVoiceShortcutVC2: INUIEditVoiceShortcutViewController?
    
    @State private var showingSiriAdder3: Bool
    @State private var showingSiriEditor3: Bool
    @State private var addVoiceShortcutVC3: INUIAddVoiceShortcutViewController?
    @State private var editVoiceShortcutVC3: INUIEditVoiceShortcutViewController?
    
    @State private var showingSiriAdder4: Bool
    @State private var showingSiriEditor4: Bool
    @State private var addVoiceShortcutVC4: INUIAddVoiceShortcutViewController?
    @State private var editVoiceShortcutVC4: INUIEditVoiceShortcutViewController?
    
    @State private var showingSiriAdder5: Bool
    @State private var showingSiriEditor5: Bool
    @State private var addVoiceShortcutVC5: INUIAddVoiceShortcutViewController?
    @State private var editVoiceShortcutVC5: INUIEditVoiceShortcutViewController?
    
    @State private var showingSiriAdder6: Bool
    @State private var showingSiriEditor6: Bool
    @State private var addVoiceShortcutVC6: INUIAddVoiceShortcutViewController?
    @State private var editVoiceShortcutVC6: INUIEditVoiceShortcutViewController?
    
    @State private var width: CGFloat? = nil
    
    init() {
        _showingSiriAdder1 = State(initialValue: false)
        _showingSiriEditor1 = State(initialValue: false)
        _addVoiceShortcutVC1 = State(initialValue: nil)
        _editVoiceShortcutVC1 = State(initialValue: nil)
        
        _showingSiriAdder2 = State(initialValue: false)
        _showingSiriEditor2 = State(initialValue: false)
        _addVoiceShortcutVC2 = State(initialValue: nil)
        _editVoiceShortcutVC2 = State(initialValue: nil)
        
        _showingSiriAdder3 = State(initialValue: false)
        _showingSiriEditor3 = State(initialValue: false)
        _addVoiceShortcutVC3 = State(initialValue: nil)
        _editVoiceShortcutVC3 = State(initialValue: nil)
        
        _showingSiriAdder4 = State(initialValue: false)
        _showingSiriEditor4 = State(initialValue: false)
        _addVoiceShortcutVC4 = State(initialValue: nil)
        _editVoiceShortcutVC4 = State(initialValue: nil)
        
        _showingSiriAdder5 = State(initialValue: false)
        _showingSiriEditor5 = State(initialValue: false)
        _addVoiceShortcutVC5 = State(initialValue: nil)
        _editVoiceShortcutVC5 = State(initialValue: nil)
        
        _showingSiriAdder6 = State(initialValue: false)
        _showingSiriEditor6 = State(initialValue: false)
        _addVoiceShortcutVC6 = State(initialValue: nil)
        _editVoiceShortcutVC6 = State(initialValue: nil)
    }
    
    var body: some View {
        List {
            HStack {
                Text("Add Expense")
                    .frame(width: width, alignment: .leading)
                    .background(CenteringView())
                    .sheet(isPresented: $showingSiriEditor1,
                           content: {
                            SiriShortcutEditor(editVoiceShortcutViewController: $editVoiceShortcutVC1)
                    })
                
                SiriButton(intent: AddExpenseIntent(),
                           shouldPresentSiriAdder: $showingSiriAdder1,
                           shouldPresentSiriEditor: $showingSiriEditor1,
                           addVoiceShortcutVC: $addVoiceShortcutVC1,
                           editVoiceShortcutVC: $editVoiceShortcutVC1)
                    .sheet(isPresented: $showingSiriAdder1,
                           content: {
                            SiriShortcutAdder(addVoiceShortcutViewController: $addVoiceShortcutVC1)
                    })
            }
            
            HStack {
                Text("Add Cash")
                    .frame(width: width, alignment: .leading)
                    .background(CenteringView())
                    .sheet(isPresented: $showingSiriEditor2,
                           content: {
                            SiriShortcutEditor(editVoiceShortcutViewController: $editVoiceShortcutVC2)
                    })
                
                SiriButton(intent: AddCashIntent(),
                           shouldPresentSiriAdder: $showingSiriAdder2,
                           shouldPresentSiriEditor: $showingSiriEditor2,
                           addVoiceShortcutVC: $addVoiceShortcutVC2,
                           editVoiceShortcutVC: $editVoiceShortcutVC2)
                    .sheet(isPresented: $showingSiriAdder2,
                           content: {
                            SiriShortcutAdder(addVoiceShortcutViewController: $addVoiceShortcutVC2)
                    })
            }

            HStack {
                Text("Show Cash-In-Hand")
                    .frame(width: width, alignment: .leading)
                    .background(CenteringView())
                    .sheet(isPresented: $showingSiriEditor3,
                           content: {
                            SiriShortcutEditor(editVoiceShortcutViewController: $editVoiceShortcutVC3)
                    })
                
                SiriButton(intent: CashInHandIntent(),
                           shouldPresentSiriAdder: $showingSiriAdder3,
                           shouldPresentSiriEditor: $showingSiriEditor3,
                           addVoiceShortcutVC: $addVoiceShortcutVC3,
                           editVoiceShortcutVC: $editVoiceShortcutVC3)
                    .sheet(isPresented: $showingSiriAdder3,
                           content: {
                            SiriShortcutAdder(addVoiceShortcutViewController: $addVoiceShortcutVC3)
                    })
            }
            
            
            HStack {
                Text("Show Recent Expenses")
                    .frame(width: width, alignment: .leading)
                    .background(CenteringView())
                    .sheet(isPresented: $showingSiriEditor4,
                           content: {
                            SiriShortcutEditor(editVoiceShortcutViewController: $editVoiceShortcutVC4)
                    })
                
                SiriButton(intent: RecentExpensesIntent(),
                           shouldPresentSiriAdder: $showingSiriAdder4,
                           shouldPresentSiriEditor: $showingSiriEditor4,
                           addVoiceShortcutVC: $addVoiceShortcutVC4,
                           editVoiceShortcutVC: $editVoiceShortcutVC4)
                    .sheet(isPresented: $showingSiriAdder4,
                           content: {
                            SiriShortcutAdder(addVoiceShortcutViewController: $addVoiceShortcutVC4)
                    })
            }
            
            
            HStack {
                Text("Show Recent Cash Additions")
                    .frame(width: width, alignment: .leading)
                    .background(CenteringView())
                    .sheet(isPresented: $showingSiriEditor5,
                           content: {
                            SiriShortcutEditor(editVoiceShortcutViewController: $editVoiceShortcutVC5)
                    })
                
                SiriButton(intent: RecentCashIntent(),
                           shouldPresentSiriAdder: $showingSiriAdder5,
                           shouldPresentSiriEditor: $showingSiriEditor5,
                           addVoiceShortcutVC: $addVoiceShortcutVC5,
                           editVoiceShortcutVC: $editVoiceShortcutVC5)
                    .sheet(isPresented: $showingSiriAdder5,
                           content: {
                            SiriShortcutAdder(addVoiceShortcutViewController: $addVoiceShortcutVC5)
                    })
            }
            
            
            HStack {
                Text("Add Payment")
                    .frame(width: width, alignment: .leading)
                    .background(CenteringView())
                    .sheet(isPresented: $showingSiriEditor6,
                           content: {
                            SiriShortcutEditor(editVoiceShortcutViewController: $editVoiceShortcutVC6)
                    })
                
                SiriButton(intent: AddPaymentIntent(),
                           shouldPresentSiriAdder: $showingSiriAdder6,
                           shouldPresentSiriEditor: $showingSiriEditor6,
                           addVoiceShortcutVC: $addVoiceShortcutVC6,
                           editVoiceShortcutVC: $editVoiceShortcutVC6)
                    .sheet(isPresented: $showingSiriAdder6,
                           content: {
                            SiriShortcutAdder(addVoiceShortcutViewController: $addVoiceShortcutVC6)
                    })
            }
            
            
//            SiriButtonView(title: "Add Expense",
//                           width: width,
//                           intent: AddExpenseIntent(),
//                           showAdder: $showingSiriAdder1,
//                           showEditor: $showingSiriEditor1,
//                           adder: $addVoiceShortcutVC1,
//                           editor: $editVoiceShortcutVC1)
//
//            SiriButtonView(title: "Add Cash",
//                           width: width,
//                           intent: AddCashIntent(),
//                           showAdder: $showingSiriAdder2,
//                           showEditor: $showingSiriEditor2,
//                           adder: $addVoiceShortcutVC2,
//                           editor: $editVoiceShortcutVC2)
//
//            SiriButtonView(title: "Show Cash-In-Hand",
//                           width: width,
//                           intent: CashInHandIntent(),
//                           showAdder: $showingSiriAdder3,
//                           showEditor: $showingSiriEditor3,
//                           adder: $addVoiceShortcutVC3,
//                           editor: $editVoiceShortcutVC3)
//
//            SiriButtonView(title: "Show Recent Expenses",
//                           width: width,
//                           intent: RecentExpensesIntent(),
//                           showAdder: $showingSiriAdder4,
//                           showEditor: $showingSiriEditor4,
//                           adder: $addVoiceShortcutVC4,
//                           editor: $editVoiceShortcutVC4)
//
//            SiriButtonView(title: "Show Recent Cash Additions",
//                           width: width,
//                           intent: RecentCashIntent(),
//                           showAdder: $showingSiriAdder5,
//                           showEditor: $showingSiriEditor5,
//                           adder: $addVoiceShortcutVC5,
//                           editor: $editVoiceShortcutVC5)
//
//            SiriButtonView(title: "Add Payment",
//                           width: width,
//                           intent: AddPaymentIntent(),
//                           showAdder: $showingSiriAdder6,
//                           showEditor: $showingSiriEditor6,
//                           adder: $addVoiceShortcutVC6,
//                           editor: $editVoiceShortcutVC6)
        }
        .onPreferenceChange(CenteringColumnPreferenceKey.self) { preferences in
            for p in preferences {
                let oldWidth = width ?? CGFloat.zero
                if p.width > oldWidth {
                    width = p.width
                }
            }
        }
    }
}

struct SiriButtonView: View {
    private var title: String
    private var width: CGFloat?
    private var intent: INIntent
    
    @Binding private var showAdder: Bool
    @Binding private var showEditor: Bool
    
    private var adder: Binding<INUIAddVoiceShortcutViewController?>
    private var editor: Binding<INUIEditVoiceShortcutViewController?>
    
    init(title: String,
         width: CGFloat?,
         intent: INIntent,
         showAdder: Binding<Bool>,
         showEditor: Binding<Bool>,
         adder: Binding<INUIAddVoiceShortcutViewController?>,
         editor: Binding<INUIEditVoiceShortcutViewController?>) {
        self.title = title
        self.width = width
        self.intent = intent
        self._showAdder = showAdder
        self._showEditor = showEditor
        self.adder = adder
        self.editor = editor
    }
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: width, alignment: .leading)
                .background(CenteringView())
            SiriButton(intent: RecentExpensesIntent(),
                       shouldPresentSiriAdder: $showAdder,
                       shouldPresentSiriEditor: $showEditor,
                       addVoiceShortcutVC: adder,
                       editVoiceShortcutVC: editor)
        }
        .sheet(isPresented: $showEditor,
               content: {
                SiriShortcutEditor(editVoiceShortcutViewController: editor)
        })
        .sheet(isPresented: $showAdder,
               content: {
                SiriShortcutAdder(addVoiceShortcutViewController: adder)
        })
    }
}

#Preview {
    SiriShortcuts()
}
