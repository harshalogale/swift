//
//  ExpenseDetail.swift
//  CashTracker
//  Abstract:
//  A view showing the details for an expense.
//
//  Created by Harshal Ogale

import SwiftUI
import CashTrackerShared

struct ExpenseDetail: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var expense: Expense!
    
    @State private var isExpenseEditFormVisible = false
    @State private var isImagePopupVisible = false
    
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    
    init(_ expense:Expense) {
        _expense = State(initialValue: expense)
    }
    
    var body: some View {
        VStack {
            MapView(coordinate: expense.expenseCoordinate, title: expense.business, subTitle: expense.address)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
                .overlay(
                    CircleImage(image: expense.image)
                        .contentShape(Circle())
                        .onTapGesture() { self.isImagePopupVisible.toggle() }
                        .offset(x: 0, y: 200)
                        .padding(.bottom, 100)
            )
                .popover(isPresented: self.$isImagePopupVisible,
                         arrowEdge: .bottom) {
                            VStack {
                                Spacer()
                                self.expense?.image
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(self.scale)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .gesture(MagnificationGesture()
                            .onChanged { val in
                                let delta = val / self.lastScaleValue
                                self.lastScaleValue = val
                                let newScale = self.scale * delta
                                
                                // clamp image scale factor
                                self.scale = min(2.0, newScale)
                                self.scale = max(0.5, newScale)
                            }
                            .onEnded { val in
                                // without this the next gesture will be broken
                                self.lastScaleValue = 1.0
                            })
                                .gesture(TapGesture(count: 2)
                                    .onEnded({ () in
                                        self.scale = 1.0
                                    }))
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(verbatim: expense.title ?? "")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "pencil.circle.fill")
                            .imageScale(.large)
                        
                        Text("Edit").fontWeight(.bold)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture() {
                        self.isExpenseEditFormVisible.toggle()
                    }
                    .padding(.horizontal, 10)
                    .popover(isPresented: self.$isExpenseEditFormVisible,
                             arrowEdge: .bottom) {
                                ExpenseEntry(self.$expense)
                                    .environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }
                
                HStack {
                    Text(CashTrackerSharedHelper.currencyFormatter.string(from:expense.amount as NSNumber) ?? "").font(.title)
                    Spacer()
                }
                
                HStack {
                    Text((nil != expense.datetime ? DateFormatter.expDateTimeFormatter.string(from: expense.datetime!): ""))
                        .font(.subheadline)
                    Spacer()
                }
                
                HStack {
                    Text(LocalizedStringKey(expense.category?.title ?? ""))
                        .font(.subheadline)
                    Spacer()
                }
                
                if nil != expense.business && !expense.business!.isEmpty {
                    HStack {
                        Text(verbatim: expense.business ?? "")
                            .font(.subheadline)
                        Spacer()
                    }
                }
                
                HStack(alignment: .top) {
                    Text(verbatim: expense.address ?? "")
                        .font(.subheadline)
                    Spacer()
                }
                
                if nil != expense.notes && !expense.notes!.isEmpty {
                    Text("Notes").font(.headline) + Text(":").font(.headline)
                    HStack {
                        Text(verbatim: expense.notes ?? "")
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
            .padding()
            .padding(.top, 80)
            
            Spacer()
        }
    }
}

//struct ExpenseDetail_Preview: PreviewProvider {
//    static var previews: some View {
//        let userData = UserData()
//        return ExpenseDetail(expense: userData.expenses[0])
//            .environmentObject(userData)
//    }
//}


struct BlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: effect)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}
