//
//  AddExpenseIntentHandler.swift
//  CashTrackerIntents
//
//  Created by Harshal Ogale
//

import Foundation
import CashTrackerShared
import Intents
import CoreLocation
import CoreData

public class AddExpenseIntentHandler: NSObject, AddExpenseIntentHandling, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var sourcelocation: CLLocationCoordinate2D?
    
    public override init() {
        super.init()
        //print("AddExpenseIntentHandler.init: locations services enabled: \(CLLocationManager.locationServicesEnabled())")
        
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
        //print("AddExpenseIntentHandler: CoreLocation update: coord = \(String(describing: manager.location?.coordinate))")
        sourcelocation = manager.location?.coordinate
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("AddExpenseIntentHandler: location manager didFail = \(error)")
    }
    
    // MARK: - Intents
    
    public func handle(intent: AddExpenseIntent, completion: @escaping (AddExpenseIntentResponse) -> Void) {
        print("handle AddExpenseIntent")
        
        let ctx = CashTrackerSharedHelper.persistentContainer.viewContext
        
        let exp = Expense(context: ctx)
        exp.id = UUID()
        let title = intent.title ?? "New Expense"
        exp.title = title
        exp.amount = intent.amount?.amount?.doubleValue ?? 0.0
        exp.currencyCode = intent.amount?.currencyCode?.uppercased() ?? CashTrackerSharedHelper.currencyCode
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
        
        let amt = intent.amount ?? INCurrencyAmount(amount: NSDecimalNumber(value: 0.0), currencyCode: exp.currencyCode!)
        //let amt = INCurrencyAmount(amount: NSDecimalNumber(value: 0.0), currencyCode: exp.currencyCode!)
        
        completion(AddExpenseIntentResponse.success(amount: amt, title: title))
    }

    public func resolveTitle(for intent: AddExpenseIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        print("resolveTitle \(intent.title ?? "empty")")
        if nil == intent.title || intent.title!.isEmpty {
            completion(INStringResolutionResult.needsValue())
        } else {
            completion(INStringResolutionResult.success(with: intent.title!))
        }
    }

    public func resolveAmount(for intent: AddExpenseIntent, with completion: @escaping (AddExpenseAmountResolutionResult) -> Void) {
        print("resolveAmount \(String(describing: intent.amount))")

        let result: AddExpenseAmountResolutionResult

        if let currencyAmount = intent.amount, let amount = currencyAmount.amount {
            if amount.intValue < 0 {
                result = AddExpenseAmountResolutionResult.unsupported(forReason: AddExpenseAmountUnsupportedReason.lessThanMinimumValue)
            } else {
                result = AddExpenseAmountResolutionResult.success(with: intent.amount!)
            }
        } else {
            // No amount provided.
            result = AddExpenseAmountResolutionResult.needsValue()
        }

        completion(result)
    }
}
