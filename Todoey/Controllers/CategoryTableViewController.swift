//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Micaella Morales on 12/24/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

class CategoryTableViewController: SwipeTableViewController {
    
    var categoryManager = CategoryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryManager.loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist") }
        
        navBar.standardAppearance.backgroundColor = UIColor(hex: "#1d9bf6ff")
        navBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.scrollEdgeAppearance = navBar.standardAppearance
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let categoryName = textField.text, !categoryName.isEmpty {
                self.categoryManager.create(with: categoryName, color: UIColor.random.hexString)
                self.tableView.reloadData()
                
                if let categories = self.categoryManager.categories {
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryManager.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        if let category = categoryManager.categories?[indexPath.row] {
            let bgColor = UIColor(hex: category.color)
            cell.textLabel?.text = category.name
            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = bgColor.isDark ? .white : .black
        }
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Swipe table view methods
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = categoryManager.categories?[indexPath.row] {
            categoryManager.delete(category)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.itemManager.category = categoryManager.categories?[indexPath.row]
        }
        
    }
    
}
