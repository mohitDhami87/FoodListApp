//
//  FoodModel.swift
//  FoodListApp
//
//  Created by Mohit Sharma on 12/03/23.
//

import Foundation
import RealmSwift

class Food:Object {
    @Persisted var foodName: String
    @Persisted var subtitle: String
    
    convenience init(foodName: String, subtitle: String) {
        self.init()
        self.foodName = foodName
        self.subtitle = subtitle
    }
}
