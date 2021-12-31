//
//  CategoryManager.swift
//  Todoey
//
//  Created by Micaella Morales on 12/30/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

struct CategoryManager {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    mutating func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func create(with categoryName: String, color: String) {
        let newCategory = Category()
        newCategory.name = categoryName
        newCategory.color = color
        
        do {
            try realm.write({
                realm.add(newCategory)
            })
        } catch {
            print("Error adding category \(error)")
        }
    }
    
    func delete(_ category: Category) {
        do {
            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
        } catch {
            print("Error deleting category \(error)")
        }
    }

    
}
