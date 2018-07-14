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
//35
import SwipeCellKit

//36 adopt SwipeTableViewCellDelegate protocol, read documentation, about usage!
class CategoryViewController: UITableViewController{

    //11
    let realm = try! Realm() //first time creaing realm will fail if no resources
    
    //15
    var categories: Results<Category>? //auto update container like list and array
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //20
        loadCategories() //initialize categories, the result container which auto updates according to changes in realm
        
    }
    //MARK: - TableView Datasource Methods
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //17
        return categories?.count ?? 1 //?? is Nil Coalescing ooperator force that when varaible happen to be nil, pick the other value, has to be in this form variable?.something ?? pick this if nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //37
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        //18
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categgoriees Added Yet"
        
        //38
        cell.delegate = self
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
        categories = realm.objects(Category.self) // return auto update container  Result<Element>, which contains object of the specified type, results will update itself when changes are made that effects the values of results, ie auto update, dont need append this categoories
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
            //16
            //self.categories.append(newCategory) // dont need append because results is an auto update container, //auto update base on realm, it gets updated whenever u write something in realm
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
            //19
            destionationVC.selectedCategory = categories?[indexPath.row]
            
            destionationVC.loadItems()
        }
        
    }
}

//MARK: - Swipe Cell delegate methods

//36 adopt SwipeTableViewCellDelegate protocol, read documentation, about usage!
extension CategoryViewController: SwipeTableViewCellDelegate {
    //39
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted")
        }
        
        // customize the action appearance , download image from example in github of SwipeCellKit, put it in assests folder
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}
