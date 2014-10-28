//
//  DatabaseManager.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation

class DatabaseManager {


    func getFriends(userName : String) -> NSArray? {
        var friends = NSMutableArray()
        var error : NSError?
        var qry = PFQuery(className: "User")

        qry.orderByAscending("username")

        var qryObjects = qry.findObjects(&error)

        if error != nil {
            if qryObjects != nil {

            }
        }
        return friends
    }

    func getAllUsers() -> NSArray? {
        var friends = NSMutableArray()

//        var error : NSError?
//        var qry = PFQuery.
//
//        qry.orderByAscending("username")
//
//        var qryObjects = qry.findObjects(&error)
//
//        if error != nil {
//            if qryObjects != nil {
//                for obj in qryObjects {
//                    println("object is:\(obj)")
//                }
//            }
//        }

        return friends
    }
    
    
    
    
    
}