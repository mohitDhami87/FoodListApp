//
//  DatabaseHelper.swift
//  FoodListApp
//
//  Created by Mohit Sharma on 12/03/23.
//

import Foundation
import UIKit
import RealmSwift

class DatabaseHelper{
    static let shared = DatabaseHelper()
    
    private var realm = try! Realm()
    
    func getDatabaseURL() -> URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func saveFoodDetails(foodItem: Food){
        try! realm.write{
            realm.add(foodItem)
        }
    }
    
    func getAllFooditems() -> [Food]{
        return Array(realm.objects(Food.self))
    }
    
    func deleteFoodDetail(foodItem: Food){
        try! realm.write{
            realm.delete(foodItem)
        }
    }
    
    func updateDetails(oldDetails: Food, newDetails: Food){
        try! realm.write{
            oldDetails.foodName = newDetails.foodName
            oldDetails.subtitle = newDetails.subtitle
        }
    }
    
    func deleteAt<T:Object>(_ object:T){
        try! realm .write({
            realm.delete(object)
        })
    }
    
    func updateRow<T:Object>(_ object:T, with dictionary:[String:Any]){
        do {
            try! realm.write({
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

