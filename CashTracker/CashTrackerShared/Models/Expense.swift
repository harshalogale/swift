//
//  Expense.swift
//  CashTracker
//  Abstract: The model for an individual expense.
//
//  Created by Harshal Ogale
//

import SwiftUI
import CoreLocation
import CoreData

public class Expense: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var amount: Double
    @NSManaged public var currencyCode: String?
    @NSManaged public var notes: String?
    @NSManaged public var business: String?
    @NSManaged public var address: String?
    @NSManaged public var datetime: Date?
    @NSManaged public var category: CashCategory?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var imageData: Data?
    
    public var expenseCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude,
                               longitude: longitude)
    }
    
    public static var sortableProperties: [String] {
        ["title", "datetime", "amount", "category", "business"]
    }
    
    public static var csvHeader: String {
        "title,datetime,amount,currency,category,business,address,latitude,longitude,notes"
    }
    
    public static func csv(_ expenses:[Expense]) -> String {
        return csvHeader
            + "\r\n"
            + expenses
                .map({ $0.csv })
                .reduce("", { $0 + ($0.isEmpty ? "": "\r\n") + $1 })
    }
    
    public var csv: String {
        get {
            return ("\(title?.escapeForCSV ?? "")") + "," +
                (nil != datetime ? DateFormatter.expCSVFormatter.string(from: datetime!): "") + "," +
                "\(amount)" + "," +
                "\(currencyCode ?? "")" + "," +
                "\(category?.title ?? "")" + "," +
                ("\(business?.escapeForCSV ?? "")") + "," +
                ("\(address?.escapeForCSV ?? "")") + "," +
                "\(latitude)" + "," +
                "\(longitude)" + "," +
                ("\(notes?.escapeForCSV ?? "")")
        }
    }
}

extension String {
    var escapeForCSV: String {
        get {
            return self.replacingOccurrences(of: "\"", with: "\"\"\"")
                .replacingOccurrences(of: ",", with: "\",\"")
        }
    }
}

public extension Expense {
    var image: Image {
        if nil != imageData {
            return Image(uiImage:UIImage(data: imageData!)!)
        } else {
            return Image("expense1")
        }
    }
}

public struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}


public extension Expense {
    // ❇️ The @FetchRequest property wrapper in the ContentView will call this function
    static func allExpensesFetchRequest() -> NSFetchRequest<Expense> {
        let request = Expense.fetchRequest() as! NSFetchRequest<Expense>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        return request
    }
    
    static func expensesFetchRequest() -> NSFetchRequest<Expense> {
        let request = Expense.fetchRequest() as! NSFetchRequest<Expense>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = NSPredicate(format: "currencyCode like[c] %@", CashTrackerSharedHelper.currencyCode)
        
        return request
    }
    
    static func recentExpensesFetchRequest() -> NSFetchRequest<Expense> {
        let request = Expense.fetchRequest() as! NSFetchRequest<Expense>
        request.fetchLimit = 5
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        request.predicate = NSPredicate(format: "currencyCode like[c] %@", CashTrackerSharedHelper.currencyCode)
        
        return request
    }
}
