//
//  AddPaymentIntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Foundation
import CashTrackerShared
import Intents
import CoreLocation
import CoreData

public class AddPaymentIntentHandler: NSObject, AddPaymentIntentHandling, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var sourcelocation: CLLocationCoordinate2D?
    
    public override init() {
        super.init()
        //print("AddPaymentIntentHandler.init: locations services enabled: \(CLLocationManager.locationServicesEnabled())")
        
        DispatchQueue.main.async { [weak self] in
            self?.locationManager = CLLocationManager()
            self?.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.delegate = self
                self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                //self.locationManager.requestLocation()
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
    
    // MARK: - CoreLocation
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("AddPaymentIntentHandler: CoreLocation update: coord = \(String(describing: manager.location?.coordinate))")
        sourcelocation = manager.location?.coordinate
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("AddPaymentIntentHandler: location manager didFail = \(error)")
    }
    
    // MARK: - Intents
    
    public func handle(intent: AddPaymentIntent, completion: @escaping (AddPaymentIntentResponse) -> Void) {
        print("handle AddPaymentIntent")
        
        let ctx = CashTrackerSharedHelper.persistentContainer.viewContext
        
        var title: String = "New Expense"
        var amount: Double = 0.0
        
        let exp = Expense(context: ctx)
        exp.id = UUID()
        
        if let details = intent.details, let mid = details.range(of: " for ") {
            title = String(details.suffix(from: mid.upperBound))
            var strAmt = String(details.prefix(upTo: mid.lowerBound))
            
            if let range = strAmt.range(of: "\\d+(\\.\\d*)?", options: .regularExpression) {
                strAmt = String(strAmt[range])
            }
            
            amount = (strAmt as NSString).doubleValue
            
            print("details = \(details)")
            print("title   = \(title)")
            print("strAmt  = \(strAmt)")
            print("amount  = \(amount)")
            
        } else {
            exp.notes = intent.details
        }
        
        exp.title = title
        exp.amount = amount
        exp.currencyCode = CashTrackerSharedHelper.currencyCode
        exp.datetime = Date()
        
        // TODO: !!! Calling sync on main thread. Need to make sure this is appropriate. !!!
        DispatchQueue.main.sync {
            sourcelocation = locationManager.location?.coordinate
            locationManager.stopUpdatingLocation()
        }
        
        if let sourcelocation = sourcelocation {
            exp.latitude = sourcelocation.latitude
            exp.longitude = sourcelocation.longitude
        }
        
        do {
           print("saving expense object")
           try ctx.save()
        } catch {
           print(error)
        }
        
        let amt = INCurrencyAmount(amount: NSDecimalNumber(value: amount), currencyCode: exp.currencyCode!)
        
        completion(AddPaymentIntentResponse.success(amount: amt, title: title))
    }

    public func resolveDetails(for intent: AddPaymentIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        print("resolveDetails \(intent.details ?? "empty")")
        if nil == intent.details || intent.details!.isEmpty {
            completion(INStringResolutionResult.needsValue())
        } else {
            completion(INStringResolutionResult.success(with: intent.details!))
        }
    }
}
