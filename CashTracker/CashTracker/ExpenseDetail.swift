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
    @State private var expense: Expense!
    
    @State private var isExpenseEditFormVisible = false
    @State private var isImagePopupVisible = false
    
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    
    init(_ expense: Expense) {
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
                        .onTapGesture() { isImagePopupVisible.toggle() }
                        .offset(x: 0, y: 200)
                        .padding(.bottom, 100)
                )
                .popover(isPresented: $isImagePopupVisible,
                         arrowEdge: .bottom) {
                    VStack {
                        Spacer()
                        expense?.image
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(scale)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .gesture(MagnificationGesture()
                        .onChanged { val in
                            let delta = val / lastScaleValue
                            lastScaleValue = val
                            let newScale = scale * delta

                            // clamp image scale factor
                            scale = min(2.0, newScale)
                            scale = max(0.5, newScale)
                        }
                        .onEnded { val in
                            // without this the next gesture will be broken
                            lastScaleValue = 1.0
                        })
                    .gesture(TapGesture(count: 2)
                        .onEnded({ () in
                            scale = 1.0
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
                        isExpenseEditFormVisible.toggle()
                    }
                    .padding(.horizontal, 10)
                    .popover(isPresented: $isExpenseEditFormVisible,
                             arrowEdge: .bottom) {
                        ExpenseEntry($expense)
                    }
                }
                
                HStack {
                    Text(CashTrackerSharedHelper.currencyFormatter.string(from: expense.amount as NSNumber) ?? "").font(.title)
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

#Preview {
    let context = CashTrackerSharedHelper.persistentContainer.viewContext
    ExpenseDetail(Expense(context: context))
}

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
