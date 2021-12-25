//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Micaella Morales on 12/23/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var toDoItems = [Item]()
    var filteredToDoItems = [Item]()
    
    let blur = UIBlurEffect(style: .extraLight)
    let blurView = UIVisualEffectView(effect: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        filteredToDoItems = toDoItems
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredToDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        let item = filteredToDoItems[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        

        return cell
    }

    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filteredToDoItems[indexPath.row].done = !filteredToDoItems[indexPath.row].done
        
        //    context.delete(toDoItems[indexPath.row])
        //    toDoItems.remove(at: indexPath.row)
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            if let itemTitle = textField.text, !itemTitle.isEmpty {
                let newItem = Item(context: self.context)
                newItem.title = itemTitle
                newItem.done = false
                self.toDoItems.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            toDoItems = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

}

//MARK: - Search bar delegate

extension ToDoListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredToDoItems = toDoItems
        } else {
            filteredToDoItems = toDoItems.filter({ (item) in
                return item.title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
        }
        
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.showsCancelButton = true
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        filteredToDoItems = toDoItems
        tableView.reloadData()
    }
    
}
