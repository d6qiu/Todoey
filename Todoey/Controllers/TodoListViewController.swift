//
//  ViewController.swift
//  Todoey
//
//  Created by wenlong qiu on 7/4/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    //13
    var selectedCategory : Category? {
        didSet{ //gets triggered as soon as selectedCategory gets set with a value
            loadItems()
        }
    }
    //create fiel apth to documents folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].setValue(!itemArray[indexPath.row].done, forKey: "done")
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        //dismiss the shade/highlight when select row
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            //14
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    //17 add predicate to parameter, have to set = nil otherwise have to enter argument when call
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //15
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //18
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Errpr fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}

//MARK: - Search Bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request :NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //16
        loadItems(with: request, predicate: request.predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
