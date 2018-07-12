//
//  CategoryViewController.swift
//  Todoey
//
//  Created by wenlong qiu on 7/10/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //1
    var categories = [Category]()
    
    //2
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        //9
        loadCategories()
        
    }
    //MARK: - TableView Datasource Methods
    
    //3
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    //4
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    //MARK: - DataManipulation Methods
    
    //8
    func saveCategories() {
        do{
            try context.save()
        } catch {
            print("Error saving categories \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    //10
    func loadCategories() {
        let request  : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            try categories = context.fetch(request)
        } catch {
            print("Error Loading categories \(error)")
        }
        tableView.reloadData()
    }
    //MARK: - Add New Categories
    
    //5
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //var textField : UITextField!
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //7
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        //6
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods
    
    //11
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //12
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //dont need to check for segue ideentifier because theres only one
        let destionationVC = segue.destination as! TodoListViewController
        //able to access tableView here because it is included when subclassing tableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destionationVC.selectedCategory = categories[indexPath.row]
            //do 13 in todolistviewController, also delete loadItems in viewDidLoad because you want loadItems coorespond to category selected
            //14
            destionationVC.loadItems()
        }
        
    }
}
