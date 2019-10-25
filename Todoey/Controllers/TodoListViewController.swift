//
//  ViewController.swift
//  Todoey
//
//  Created by wenlong qiu on 7/4/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import UIKit
//21
import RealmSwift
import ChameleonFramework
//47 change superclass to swipetableviewcontroller, also set cell's custom class to swipetableviewcell, modole to swiptcellkit, since swipetableviewcell is from swipecellkit
class TodoListViewController: SwipeTableViewController {
    
    //21.5
    let realm = try! Realm() //new acces point to realm
    
    //24, change type and rename all 
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{ //gets triggered as soon as selectedCategory gets set with a value
            //22
            loadItems()
        }
    }
    //59
    @IBOutlet weak var searchBar: UISearchBar!
    
    //create fiel apth to documents folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    //57 navigationController is nil in viewDidLoad //58 nav Bar large title color can be set in navigation controller nav bar
    override func viewWillAppear(_ animated: Bool) {
        //60, use guard if 99% wont fail, use let if 50% time will fail, use guard to avoid nested let
        guard let navBar = navigationController?.navigationBar else { fatalError("navigation controller does not exist") }
        guard let colorHex = selectedCategory?.color else { fatalError()}
        title = selectedCategory?.name //title inherited from swipetableviewcontroller, same as tableView
        guard let navBarColor = UIColor(hexString: colorHex) else {fatalError() }
        navBar.backgroundColor = navBarColor
        //navBar.barTintColor = navBarColor //background color of bar
        //tint color applys to items inside navigation bar
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        }
    //61 triggers when view about to be removed from a view hiaerachy
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else { fatalError()}
        navigationController?.navigationBar.barTintColor = originalColor //navigationcontroller should exist other wise would fail when the view appears
        navigationController?.navigationBar.backgroundColor = originalColor
//        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarManager.statusBar") as? UIView else { return }
//        statusBar.backgroundColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
    }


    
    //MARK: - Tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        //48
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //26
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //Ternary operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            //55, darken by percentage returns optional color, //56 navigation bar in nav controller prefer large titles
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) { //you can force unwrap because  todoItems is already nil checked
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added" //never trigger because todoItems exists but coount = 0
        }
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //25
        return todoItems?.count ?? 1
    }
    
    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //29
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)


    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //27
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write { //when create seomthing in the realm, make changes of objects in realm, delete objects in the realm
                        //All changes to an object (addition, modification and deletion) must be done within a write transaction.
                        let newItem = Item()
                        newItem.title = textField.text!
                        //32
                        newItem.dateCreated = Date() //gets current date
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
                
            }
            //28
            self.tableView.reloadData()

        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //23
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) //.sorted returns a Results container containing sorted objects in the list
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Errpr fetching data from context \(error)")
//        }
        tableView.reloadData()
        
    }
    
    //49
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("error deleting item, \(error)")
            }
        }
    }

}

//MARK: - Search Bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //30
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true) // 31 is Item.swift
        //33
        tableView.reloadData() //run code right now will get migration error, cause: previous items do not have property dataCreated, so it is nil in the realm, need to uninstall app in simulator
        
//        let request :NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: request.predicate)
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
