//
//  Expense+Intents.swift
//  CashTracker
//
//  Created by Harshal Ogale on 16/11/19.
//  Copyright © 2019 Harshal Ogale. All rights reserved.
//

//import Foundation
//import Intents
//
//extension Expense {
//    var intent: AddExpenseIntent {
//        let addExpenseIntent = AddExpenseIntent()
//        addExpenseIntent.title = self.title
//        addExpenseIntent.amount = INCurrencyAmount(amount: NSDecimalNumber(value: self.amount), currencyCode: Locale.current.currencyCode ?? "USD")
//
//        addExpenseIntent.suggestedInvocationPhrase = NSString.deferredLocalizedIntentsString(with: "ADD_EXPENSE_SUGGESTED_PHRASE") as String
//
//        return addExpenseIntent
//    }
//
//    public init?(from intent: AddExpenseIntent) {
//        let menuManager = SoupMenuManager()
//        guard let menuItem = menuManager.findItem(soup: intent.soup),
//            let quantity = intent.quantity
//            else { return nil }
//
//        let rawToppings = intent.toppings?.compactMap { (toppping) -> MenuItemTopping? in
//            guard let toppingID = toppping.identifier else { return nil }
//            return MenuItemTopping(rawValue: toppingID)
//        } ?? [MenuItemTopping]() // If the result of the map is nil (because `intent.toppings` is nil), provide an empty array.
//
//        switch intent.orderType {
//        case .unknown:
//            self.init(quantity: quantity.intValue, menuItem: menuItem, menuItemToppings: Set(rawToppings))
//        case .delivery:
//            guard let deliveryLocation = intent.deliveryLocation, let location = deliveryLocation.location else {
//                return nil
//            }
//            self.init(quantity: quantity.intValue,
//                      menuItem: menuItem,
//                      menuItemToppings: Set(rawToppings),
//                      deliveryLocation: Location(name: deliveryLocation.name,
//                                                 latitude: location.coordinate.latitude,
//                                                 longitude: location.coordinate.longitude))
//        case .pickup:
//            guard let storeLocation = intent.storeLocation, let location = storeLocation.location else {
//                return nil
//            }
//            self.init(quantity: quantity.intValue,
//                      menuItem: menuItem,
//                      menuItemToppings: Set(rawToppings),
//                      storeLocation: Location(name: storeLocation.name,
//                                              latitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude))
//        }
//    }
//}
