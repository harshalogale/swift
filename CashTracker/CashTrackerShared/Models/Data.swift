//
//  Data.swift
//  CashTracker
//
//  Abstract:
//  Helpers for loading images and data.
//
//  Created by Harshal Ogale

import UIKit
import SwiftUI
import CoreLocation

//let dataFileName = "expenseData.json"
//let expenseData: [Expense] = loadExpenses()
//
//func loadExpenses() -> [Expense] {
//    var expenses = [Expense]()
//    var storedExpenses: [Expense]?
//    if let data = UserDefaults.standard.value(forKey:"expenses") as? Data {
//        do {
//            let decoder = JSONDecoder()
//            storedExpenses = try decoder.decode([Expense].self, from: data)
//        } catch {
//            fatalError("Could not decode data into json")
//        }
//        
//        if let storedExpenses = storedExpenses {
//            expenses.append(contentsOf: storedExpenses)
//        }
//        
//    }
//    
//    return expenses
//}
//
//func storeExpenses(_ expenses:[Expense]) {
//    //store(dataFileName, expenses)
//    
//    let jsonData: Data
//    do {
//        let encoder = JSONEncoder()
//        jsonData = try encoder.encode(expenses)
//    } catch {
//        fatalError("Couldn't encode value to json :\n\(error)")
//    }
//    
//    UserDefaults.standard.setValue(jsonData, forKey: "expenses")
//}
//
//func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
//    let data: Data
//    
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't find \(filename) in main bundle.")
//    }
//    
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//    
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
//
//func store<T: Encodable>(_ filename: String, _ value: T) {
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't find \(filename) in main bundle.")
//    }
//    
//    let jsonData: Data
//    do {
//        let encoder = JSONEncoder()
//        jsonData = try encoder.encode(value)
//    } catch {
//        fatalError("Couldn't encode value to json :\n\(error)")
//    }
//    
//    do {
//        try jsonData.write(to: file)
//    } catch {
//        print("Failed to write JSON data to file \(filename):\n\(error.localizedDescription)")
//    }
//}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(verbatim: name))
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

