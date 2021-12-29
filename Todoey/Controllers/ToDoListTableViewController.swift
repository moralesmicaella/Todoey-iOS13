//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Micaella Morales on 12/23/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: SwipeTableViewController {
   
    let realm = try! Realm()
    
    var categoryColor: UIColor?
    var category: Category? {
        didSet {
            loadItems()
            categoryColor = UIColor(hex: category!.color)
        }
    }
    
    var toDoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist") }
        
        if let category = category {
            title = category.name
            
            navBar.standardAppearance.backgroundColor = categoryColor
            navBar.standardAppearance.titleTextAttributes = [.foregroundColor: (categoryColor!.isDark ? UIColor.white : UIColor.black)]
            navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: (categoryColor!.isDark ? UIColor.white : UIColor.black)]
            navBar.scrollEdgeAppearance? = navBar.standardAppearance
            navBar.tintColor = categoryColor!.isDark ? .white : .black
            
            navigationItem.searchController = UISearchController()
            navigationItem.hidesSearchBarWhenScrolling = false

            if let searchBar = navigationItem.searchController?.searchBar {
                searchBar.delegate = self
                searchBar.searchTextField.layer.cornerRadius = 10
                searchBar.searchTextField.layer.backgroundColor = UIColor.white.cgColor
                searchBar.tintColor = categoryColor!.isDark ? .white : .black
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            let bgColor = categoryColor!.darken(by: CGFloat(indexPath.row)/CGFloat(toDoItems!.count))
            cell.backgroundColor = bgColor
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = bgColor.isDark ? .white : .black
            cell.accessoryType = item.done ? .checkmark : .none
        } 

        return cell
    }

    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("Error updating done property of item \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            if let itemTitle = textField.text, !itemTitle.isEmpty {
                let newItem = Item()
                newItem.title = itemTitle
                newItem.done = false
                
                self.save(item: newItem)
                
                if let toDoItems = self.toDoItems {
                    let indexPath = IndexPath(row: toDoItems.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func save(item: Item) {
        do {
            try realm.write({
                realm.add(item)
                category?.items.append(item)
            })
        } catch {
            print("Error adding item \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        if let category = category {
            toDoItems = realm.objects(Item.self).where({ (item) in
                item.parentCategory.name == category.name
            })
        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }

}

//MARK: - Search bar delegate

extension ToDoListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
        } else {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        loadItems()
        tableView.reloadData()
    }
    
}
