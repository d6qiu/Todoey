//
//  CategoryViewController.swift
//  Todoey
//
//  Created by wenlong qiu on 7/10/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import UIKit
//10
import RealmSwift

class CategoryViewController: UITableViewController {

    //11
    let realm = try! Realm() //first time creaing realm will fail if no resources
    
    //15
    var categories: Results<Category>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    //MARK: - TableView Datasource Methods
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    //MARK: - DataManipulation Methods
    
    //13
    func save(category : Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    //14
    func loadCategories() {
        categories = realm.objects(Category.self) // return all objects of tye Category as Result<Element> type, which is a container type
    }
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //var textField : UITextField!
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            //12
            let newCategory = Category()
            newCategory.name = textField.text!
            //self.categories.append(newCategory)
            self.save(category: newCategory)
        }
        
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //dont need to check for segue ideentifier because theres only one
        let destionationVC = segue.destination as! TodoListViewController
        //able to access tableView here because it is included when subclassing tableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destionationVC.selectedCategory = categories[indexPath.row]
            
            destionationVC.loadItems()
        }
        
    }
}
