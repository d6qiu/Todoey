//
//  Item.swift
//  Todoey
//
//  Created by wenlong qiu on 7/12/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import Foundation
//4
import RealmSwift

//5
class Item: Object { //object is a class used to define realm object model objects
    @objc dynamic var title: String = "" //when user change value at runtime, realm update dynamically, realm monior changes in runtime, dynamic is a keyword from objective c api
    @objc dynamic var done: Bool = false // this is how u declare realm properties of basic types
    
    //9
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")// Category is the class, Category.self is the type, links two objects, establish relationship, contianer type
    //10 in Categoryview
}//6 in Category.swift
