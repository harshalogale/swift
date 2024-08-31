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
    @FetchRequest(fetchRequest: CashCategory.allCashCategoriesFetchRequest()) private var categories: FetchedResults<CashCategory>
    
    @Binding var category: CashCategory?
    
    @State private var showingCategoryPicker: Bool = false
    @State private var categoryTitle: String = ""
    @State private var newTitle: String = ""
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(category?.title ?? ""))
            Spacer()
            Button(action: {
                showingCategoryPicker = true
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
                            TextField(LocalizedStringKey(stringLiteral: "Title"), text: $newTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                let newCat = CashCategory(context: managedObjectContext)
                                newCat.id = UUID()
                                newCat.title = newTitle
                                
                                do {
                                    try managedObjectContext.save()
                                } catch {
                                    print(error)
                                }
                                
                                newTitle = ""
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor((newTitle.isEmpty
                                        || categories.contains { $0.title == newTitle }) ? .gray: .green)
                                    .imageScale(.large)
                            }.disabled(newTitle.isEmpty
                                || categories.contains { $0.title == newTitle })
                        }
                    }
                    
                    List {
                        Section(header: Text("Categories").font(.headline)) {
                            ForEach(categories, id:\.self) { cat in
                                HStack {
                                    Text(LocalizedStringKey(cat.value(forKey:"title") as! String))
                                    Spacer()
                                    if categoryTitle == cat.title {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.gray)
                                            .imageScale(.large)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    categoryTitle = cat.value(forKey:"title") as! String
                                    category = categories.first(where: { $0.title == cat.value(forKey:"title") as? String })
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        showingCategoryPicker = false
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
