//
//  DataManager.swift
//  Todoey
//
//  Created by Micaella Morales on 12/30/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

struct ItemManager {
    
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    var category: Category? {
        didSet {
            loadItems()
        }
    }
    
    mutating func loadItems() {
        if let category = category {
            toDoItems = realm.objects(Item.self).where({ (item) in
                item.parentCategory.name == category.name
            })
        }
    }
    
    func create(with itemTitle: String) {
        let newItem = Item()
        newItem.title = itemTitle
        newItem.done = false
        
        do {
            try realm.write({
                realm.add(newItem)
                category?.items.append(newItem)
            })
        } catch {
            print("Error adding item \(error)")
        }
    }
    
    func delete(_ item: Item) {
        do {
            try realm.write({
                realm.delete(item)
            })
        } catch {
            print("Error deleting item \(error)")
        }
    }
    
    func update(_ item: Item) {
        do {
            try realm.write({
                item.done = !item.done
            })
        } catch {
            print("Error updating done property of item \(error)")
        }
    }
    
    mutating func searchItem(title: String) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", title).sorted(byKeyPath: "dateCreated", ascending: true)
    }
    
}
