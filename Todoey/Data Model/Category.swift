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
import UIKit
//7
class Category: Object { //subclass realm object, also properties has to be standard data types
    @objc dynamic var name : String = ""
    //53
    @objc dynamic var color : String = ""
    //8
    let items = List<Item>() //do each category object contain its own set of items
    
}
