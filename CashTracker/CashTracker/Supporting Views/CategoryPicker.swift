//
//  CategoryPicker.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import SwiftUI
import CoreData
import CashTrackerShared

struct CategoryPicker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(fetchRequest: CashCategory.allCashCategoriesFetchRequest())
    var categories: FetchedResults<CashCategory>
    
    @Binding var category: CashCategory?
    
    @State private var showingCategoryPicker: Bool = false
    @State private var categoryTitle: String = ""
    @State var newTitle: String = ""
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(category?.title ?? ""))
            Spacer()
            Button(action: {
                self.showingCategoryPicker = true
            }) {
                HStack {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.orange)
                        .imageScale(.large)
                    Text("Select Category")
                }
            }
            .sheet(isPresented: $showingCategoryPicker) {
                Form {
                    Section(header: Text("New Category").font(.headline)) {
                        HStack {
                            Text("Title").bold().padding(.trailing, 15)
                            TextField(LocalizedStringKey(stringLiteral: "Title"), text: self.$newTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                let newCat = CashCategory(context: self.managedObjectContext)
                                newCat.id = UUID()
                                newCat.title = self.newTitle
                                
                                do {
                                    try self.managedObjectContext.save()
                                } catch {
                                    print(error)
                                }
                                
                                self.newTitle = ""
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor((self.newTitle.isEmpty
                                        || self.categories.contains { $0.title == self.newTitle }) ? .gray: .green)
                                    .imageScale(.large)
                            }.disabled(self.newTitle.isEmpty
                                || self.categories.contains { $0.title == self.newTitle })
                        }
                    }
                    
                    List {
                        Section(header: Text("Categories").font(.headline)) {
                            ForEach(self.categories, id:\.self) { cat in
                                HStack {
                                    Text(LocalizedStringKey(cat.value(forKey:"title") as! String))
                                    Spacer()
                                    if self.categoryTitle == cat.title {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.gray)
                                            .imageScale(.large)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.categoryTitle = cat.value(forKey:"title") as! String
                                    self.category = self.categories.first(where: { $0.title == cat.value(forKey:"title") as? String })
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.showingCategoryPicker = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
