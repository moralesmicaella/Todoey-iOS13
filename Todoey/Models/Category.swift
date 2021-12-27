//
//  Category.swift
//  Todoey
//
//  Created by Micaella Morales on 12/25/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var items: List<Item> = List()
}
