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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        let item = toDoItems[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
