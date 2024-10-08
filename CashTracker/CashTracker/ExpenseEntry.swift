//
//  ExpenseEntry.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CoreLocation
import CashTrackerShared
import Intents
import IntentsUI

struct ExpenseEntry: View {
   @Environment(\.managedObjectContext) var managedObjectContext
   @Environment(\.dismiss) var dismiss
   
   private var expense: Binding<Expense?>
   
   static let dtFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .medium
       dateFormatter.timeStyle = .none
       dateFormatter.locale = Locale.current
       return dateFormatter
   }()
   
   @State private var title: String
   @State private var business: String
   @State private var dt: Date
   @State private var amt: String
   @State private var currencyCode: String
   @State private var latitude: Double
   @State private var longitude: Double
   @State private var address: String
   @State private var category: CashCategory?
   @State private var notes: String
   @State private var image: Image?
   @State private var imageData: Data?
   @State private var selectedCoordinates: CLLocationCoordinate2D?
   
   @State private var modalDisplayed1: Bool
   @State private var showingCameraPicker: Bool
   @State private var showingImagePicker: Bool
   @State private var showingLocationPicker: Bool
   @State private var showingCategoryPicker: Bool
   
   @State private var width: CGFloat? = nil
   
   init(_ expense: Binding<Expense?>) {
      self.expense = expense
      
      let exp = self.expense.wrappedValue
      
      _title = State(initialValue: exp?.title ?? "")
      _business = State(initialValue: exp?.business ?? "")
      _dt = State(initialValue: exp?.datetime ?? Date())
      _amt = State(initialValue: String(describing: exp?.amount ?? 0.0))
      _currencyCode = State(initialValue: CashTrackerSharedHelper.currencyCode)
      _latitude = State(initialValue: exp?.latitude ?? 0.0)
      _longitude = State(initialValue: exp?.longitude ?? 0.0)
      _address = State(initialValue: exp?.address ?? "")
      _category = State(initialValue: exp?.category ?? nil)
      _notes = State(initialValue: exp?.notes ?? "")
      _image = State(initialValue: exp?.image)
      _imageData = State(initialValue: exp?.imageData)
      _selectedCoordinates = State(initialValue: exp?.expenseCoordinate)
      
      _modalDisplayed1 = State(initialValue: false)
      _showingCameraPicker = State(initialValue: false)
      _showingImagePicker = State(initialValue: false)
      _showingLocationPicker = State(initialValue: false)
      _showingCategoryPicker = State(initialValue: false)
      
      //donateInteraction()
   }
   
   private func donateInteraction() {
      let expIntent = AddExpenseIntent()
      //expIntent.title = "New Expense"
      //expIntent.amount = INCurrencyAmount(amount: NSDecimalNumber(value: 0.0),
      //                                    currencyCode: Locale.current.currencyCode ?? "USD")
      expIntent.suggestedInvocationPhrase = "Add Expense"
      
      let interaction = INInteraction(intent: expIntent, response: nil)
      
      interaction.donate { error in
         guard error == nil else {
            if let error = error as NSError? {
               print("Interaction donation failed: \(error.localizedDescription)")
            } else {
               print("Interaction donation failed: Unknown error")
            }
            return
         }
      }
   }
   
   var body: some View {
      Form {
         Section (header:
            VStack {
            HStack {
               Spacer()
               Text("New Expense Entry").font(.title).bold()
               Spacer()
            }
            HStack {
               Button(action: {
                  dismiss()
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     dt = Date()
                     title = ""
                     amt = "0.0"
                     business = ""
                     address = ""
                     notes = ""
                     imageData = nil
                     image = nil
                     ImagePicker.shared.imageInfo = nil
                     selectedCoordinates = nil
                     category = nil
                  }
               }) {
                  Image(systemName: "text.badge.xmark")
                     .imageScale(.large)
                     .foregroundColor(.red)
                  
                  Text("Cancel")
                     .foregroundColor(.red)
                     .font(.headline)
                     .fontWeight(.bold)
                     .padding(5)
                     .padding(.trailing, 15)
               }
               
               Spacer()
               
               Button(action: {
                  let exp = expense.wrappedValue ?? Expense(context: managedObjectContext)
                  exp.id = expense.wrappedValue?.id ?? UUID()
                  exp.title = title.isEmpty ? "New Expense": title
                  
                  if let doubleAmt = Double(amt) {
                     exp.amount = doubleAmt
                  }
                  
                  exp.currencyCode = currencyCode
                  exp.datetime = dt
                  exp.business = business
                  exp.address = address
                  exp.notes = notes
                  exp.category = category
                  exp.imageData = imageData
                  exp.latitude = selectedCoordinates?.latitude ?? 0
                  exp.longitude = selectedCoordinates?.longitude ?? 0
                  
                  do {
                     print("saving expense object")
                     try managedObjectContext.save()
                     if nil != expense.wrappedValue {
                        expense.wrappedValue = exp
                     }
                  } catch {
                     print(error)
                  }
                  
                  dismiss()
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     dt = Date()
                     title = ""
                     amt = "0.0"
                     business = ""
                     address = ""
                     notes = ""
                     imageData = nil
                     image = nil
                     ImagePicker.shared.imageInfo = nil
                     selectedCoordinates = nil
                     category = nil
                  }
               }) {
                  HStack {
                     Image(systemName: nil != expense.wrappedValue ? "pencil.circle.fill": "plus.circle.fill")
                     //.foregroundColor(title.isEmpty && 0 == (Double(amt) ?? 0) ? .gray: .green)
                        .foregroundColor(.green)
                        .imageScale(.large)
                     Text(nil != expense.wrappedValue ? "Update":  "Add").font(.headline).bold()
                  }
               }.disabled(title.isEmpty && 0 == (Double(amt) ?? 0))
            }
         }
         ) {
            HStack {
               Text("Title").bold().padding(.trailing, 15)
                  .frame(width: width, alignment: .leading)
                  .lineLimit(1)
                  .background(CenteringView())
               TextField(LocalizedStringKey(stringLiteral: "Title"), text: $title)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
               Text("Amount").bold().padding(.trailing, 15)
                  .frame(width: width, alignment: .leading)
                  .lineLimit(1)
                  .background(CenteringView())
               TextField(LocalizedStringKey(stringLiteral: "Amount"), text: $amt)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
               VStack {
                  HStack {
                     Text("Business").bold().padding(.trailing, 15)
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                     TextField(LocalizedStringKey(stringLiteral: "Business"), text: $business)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                  }
                  
                  HStack {
                     Text("Address").bold().padding(.trailing, 15)
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                     TextField(LocalizedStringKey(stringLiteral: "Address"), text: $address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                  }
               }
               VStack {
                  Button(action: {
                     print("show map")
                     showingLocationPicker = true
                  }) {
                     HStack {
                        Image(systemName: "map.fill")
                           .foregroundColor(.orange)
                           .imageScale(.large)
                        Text("Map")
                     }
                  }.sheet(isPresented: $showingLocationPicker) {
                     ZStack {
                        LocationPicker(onSelect: { (newCoord, name, addr) in
                           selectedCoordinates = newCoord
                           business = name
                           address = addr
                        })
                           .edgesIgnoringSafeArea(.vertical)
                           .overlay(Button(action: {
                              print("hide map")
                              showingLocationPicker = false
                           }, label: {
                              Image(systemName: "xmark.circle.fill")
                                 .foregroundColor(.gray)
                                 .imageScale(.large)
                           }).position(x: 30, y: 30))
                     }
                  }
               }
            }
            
            HStack {
               Text("Category").bold().padding(.trailing, 15)
                  .frame(width: width, alignment: .leading)
                  .lineLimit(1)
                  .background(CenteringView())
               CategoryPicker(category: $category)
            }
            
            HStack {
               Text("Notes").bold().padding(.trailing, 15)
                  .frame(width: width, alignment: .leading)
                  .lineLimit(1)
                  .background(CenteringView())
               TextField(LocalizedStringKey(stringLiteral: "Notes"), text: $notes)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
               Text("Date").bold().padding(.trailing, 10)
                  .frame(width: width, alignment: .leading)
                  .lineLimit(1)
                  .background(CenteringView())
               VStack {
                  Text(DateFormatter.expDateOnlyFormatter.string(from: dt)).padding(.trailing, 15)
                  Text(DateFormatter.expTimeOnlyFormatter.string(from: dt)).padding(.trailing, 15)
               }
               Spacer()
               Button(action: {
                  modalDisplayed1 = true
               }){
                  HStack {
                     Image(systemName: "calendar")
                        .foregroundColor(.orange)
                        .imageScale(.large)
                     Text("Select Date")
                  }
               }.sheet(isPresented: $modalDisplayed1, content: {
                  DatePickerView("Select Date", $dt)
               })
               Spacer()
            }
            
            HStack {
               Text("Image").bold().padding(.trailing, 10)
                  .frame(width: width, alignment: .leading)
                  .lineLimit(1)
                  .background(CenteringView())
               
               HStack {
                  Image(systemName: "photo.fill")
                     .foregroundColor(.orange)
                     .imageScale(.large)
                  Text("Photo Library")
               }.onTapGesture {
                  showingImagePicker = true
                  ImagePicker.pickerType = UIImagePickerController.SourceType.photoLibrary
               }.sheet(isPresented: $showingImagePicker, content: {
                  ImagePicker.shared.view
               }).onReceive(ImagePicker.shared.$imageInfo) { imageInfo in
                  // This gets called when the image is picked.
                  // sheet/onDismiss gets called when the picker completely leaves the screen
                  image = imageInfo?.0
                  imageData = imageInfo?.1
               }
               
               Spacer()
               
               if UIImagePickerController.isSourceTypeAvailable(.camera) {
                  HStack {
                     Image(systemName: "camera.fill")
                        .foregroundColor(.orange)
                        .imageScale(.large)
                     Text("Camera")
                  }.onTapGesture {
                     showingCameraPicker = true
                     ImagePicker.pickerType = UIImagePickerController.SourceType.camera
                  }.sheet(isPresented: $showingCameraPicker, content: {
                     ImagePicker.shared.view
                  }).onReceive(ImagePicker.shared.$imageInfo) { imageInfo in
                     // This gets called when the image is picked.
                     // sheet/onDismiss gets called when the picker completely leaves the screen
                     image = imageInfo?.0
                     imageData = imageInfo?.1
                  }
                  Spacer()
               }
            }
            
            // do not show image preview if the user has not selected an image
            if nil != image && nil != imageData {
               HStack {
                  Spacer()
                  // show selected image
                  image!
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 100)
                     .overlay(
                        Button(action: {
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                              image = nil
                              imageData = nil
                           }
                        }) {
                           Image(systemName: "xmark.circle.fill")
                              .foregroundColor(.red)
                              .imageScale(.large)
                        }
                        , alignment: .topLeading)
                  Spacer()
               }
            }
         }.onPreferenceChange(CenteringColumnPreferenceKey.self) { preferences in
            for p in preferences {
               let oldWidth = width ?? CGFloat.zero
               if p.width > oldWidth {
                  width = p.width
               }
            }
         }
      }
   }
}
