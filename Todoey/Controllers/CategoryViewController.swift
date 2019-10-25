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
//50 read documentaion podfile, pod install
import ChameleonFramework


//43 inherit superclass
class CategoryViewController: SwipeTableViewController{

    //11
    let realm = try! Realm() //first time creaing realm will fail if no resources
    
    //15
    var categories: Results<Category>? //auto update container like list and array
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //20
        loadCategories() //initialize categories, the result container which auto updates according to changes in realm
        //52
        tableView.separatorStyle = .none
        
    }
    //MARK: - TableView Datasource Methods
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //17
        let count = categories?.count ?? 1
        return count //?? is Nil Coalescing ooperator force that when varaible happen to be nil, pick the other value, has to be in this form variable?.something ?? pick this if nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //44
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            //18
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categgoriees Added Yet"
            
            //54
            //guard let categoryColor = UIColor(hex: category.color) else {fatalError()}
            guard let categoryColor  = UIColor(hexString: category.color, withAlpha: 1) else {fatalError()}// remember migration will happen after added new property, will mismatch with previous category objects
            //62
            cell.backgroundColor = categoryColor
            //cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
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
    //MARK: - Deleta data from swipe
    override func updateModel(at indexPath: IndexPath) {
        //41
        if let categoryForDeletion = self.categories?[indexPath.row] { //everytime variable is optional, perform safty to unwrap it, unless for sure its never nil use !
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            
        }
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
            //51
            newCategory.color  = UIColor.randomFlat().hexValue() //hexvalue return color name as string
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
            
            //destionationVC.loadItems()
        }
        
    }
}





