//
//  Credit.swift
//  CashTracker
//
//  Created by Harshal Ogale
//

import Foundation
import CoreData

public class Credit: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var amount: Double
    @NSManaged public var currencyCode: String?
    @NSManaged public var notes: String?
    @NSManaged public var datetime: Date?
}

public extension Credit {
    
    static var sortableProperties: [String] {
        ["title", "datetime", "amount"]
    }
}

public extension Credit {
    
    static func recentCreditsFetchRequest() -> NSFetchRequest<Credit> {
        let request = Credit.fetchRequest() as! NSFetchRequest<Credit>
        request.fetchLimit = 5
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        request.predicate = NSPredicate(format: "currencyCode like[c] %@", CashTrackerSharedHelper.currencyCode)
        
        return request
    }
    
    static func allCreditsFetchRequest() -> NSFetchRequest<Credit> {
        let request = Credit.fetchRequest() as! NSFetchRequest<Credit>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        
        return request
    }
    
    static func creditsFetchRequest() -> NSFetchRequest<Credit> {
        let request = Credit.fetchRequest() as! NSFetchRequest<Credit>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: false)]
        request.predicate = NSPredicate(format: "currencyCode like[c] %@", CashTrackerSharedHelper.currencyCode)
        
        return request
    }
    
    static func sumCreditsFetchRequest() -> NSFetchRequest<NSDictionary> {
        let keyExpr = NSExpression(forKeyPath: "amount")
        
        //create the NSExpression to tell our NSExpressionDescription which calculation we are performing.
        let sumExpr = NSExpression(forFunction: "sum:", arguments: [keyExpr])
        
        let exprDescr = NSExpressionDescription()
        exprDescr.name = "total"
        exprDescr.expression = sumExpr
        exprDescr.expressionResultType = NSAttributeType.doubleAttributeType
        
        let request = Credit.fetchRequest() as! NSFetchRequest<NSDictionary>
        request.predicate = NSPredicate(format: "currencyCode like[c] %@", CashTrackerSharedHelper.currencyCode)
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        request.propertiesToFetch = [exprDescr]
        
        return request
    }
}


public extension Credit {
    
    static var csvHeader: String {
        "title,datetime,amount,currency,notes"
    }
    
    static func csv(_ credits:[Credit]) -> String {
        return csvHeader
            + "\r\n"
            + credits
                .map({ $0.csv })
                .reduce("", { $0 + ($0.isEmpty ? "": "\r\n") + $1 })
    }
    
    var csv: String {
        get {
            return ("\(title?.escapeForCSV ?? "")") + "," +
                (nil != datetime ? DateFormatter.expCSVFormatter.string(from: datetime!): "") + "," +
                "\(amount)" + "," +
                ("\(currencyCode?.escapeForCSV ?? "")") + "," +
                ("\(notes?.escapeForCSV ?? "")")
        }
    }
}
