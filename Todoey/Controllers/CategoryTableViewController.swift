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
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist") }
        
        navBar.standardAppearance.backgroundColor = UIColor(hex: "#1d9bf6ff")
        navBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.scrollEdgeAppearance = navBar.standardAppearance
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        if let category = categories?[indexPath.row] {
            let bgColor = UIColor(hex: category.color)
            cell.textLabel?.text = category.name
            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = bgColor.isDark ? .white : .black
        }
        
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
                newCategory.color = UIColor.random.hexString
                
                self.save(category: newCategory)
                
                if let categories = self.categories {
                    let indexPath = IndexPath(row: categories.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
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
                    realm.delete(category.items)
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

