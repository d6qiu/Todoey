//
//  AppDelegate.swift
//  Todoey
//
//  Created by wenlong qiu on 7/4/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import UIKit
//1
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //8
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        //2
        do {
            _ = try Realm() //replace let realm with underscore because variable realm is never used here
        } catch {
            print("Error initializting new realm, \(error)")
        } //3 make new swift file called Item & Category put it in Data model folder
    
        return true
    }

    //34 delete all context related methods, dont even need to save data when application terminates, because realm saved already

    


}

