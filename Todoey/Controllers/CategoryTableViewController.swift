//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Micaella Morales on 12/24/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var selectedCategory: Category?
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCategory = categories?[indexPath.row]
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let categoryName = textField.text, !categoryName.isEmpty {
                let newCategory = Category()
                newCategory.name = categoryName
                
                self.save(category: newCategory)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error adding category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        destinationVC.category = selectedCategory
        
    }
    
}

