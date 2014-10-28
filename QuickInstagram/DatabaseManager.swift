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

    func getAllUsersButLogged(userName : String) -> NSArray? {
        var friends = NSMutableArray()
        var error : NSError?

        var qry = PFUser.query()
        qry.whereKey("username", notEqualTo:userName)


        qry.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for r in results {
                    println("object is:\(r)")
                }
            }
            else {
                println("error:\(error)")
            }
        }




        return friends
    }
    
    
    
    
    
}