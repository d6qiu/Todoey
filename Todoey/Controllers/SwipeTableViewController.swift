//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by wenlong qiu on 7/14/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import UIKit
//35
import SwipeCellKit

//36 adopt SwipeTableViewCellDelegate protocol with inheritance, read documentation about usage!
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate{

    var cell: UITableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //40 adjust the height to correspond to trash icon's height
        tableView.rowHeight = 80.0

    }
    
    
    //TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //37
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell // if error say could not cast because the category cell in mainstory is not linked to swipetableiecello class, so set the custom class and moduel to swipecellkit, also change both todolistview tablecell and categoryview tablecell identitifier to cell
        //38
        cell.delegate = self
        return cell
    }
    //39 from swipecellkit, triggers when user start swiping
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //46
            self.updateModel(at: indexPath)
        }
        // customize the action appearance , download image from example in github of SwipeCellKit, put it in assests folder
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    //42 copied from documentatioon
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive //this includes functionality of tableView.reloadData(), so dont need that line in the completion handler of the above method
        return options
    }
    //45
    func updateModel(at indexPath: IndexPath) {
        //update data model
    }

  
}
