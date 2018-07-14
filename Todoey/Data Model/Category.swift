//
//  Category.swift
//  Todoey
//
//  Created by wenlong qiu on 7/12/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import Foundation
//6
import RealmSwift

//7
class Category: Object { //subclass realm object
    @objc dynamic var name : String = ""
    
    //8
    let items = List<Item>() //do each category object contain its own set of items
    
}
