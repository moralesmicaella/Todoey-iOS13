//
//  Item.swift
//  Todoey
//
//  Created by Micaella Morales on 12/25/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateCreated: Date = Date()
    @Persisted var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
