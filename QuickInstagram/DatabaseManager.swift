//
//  DatabaseManager.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation

class DatabaseManager : NSObject{

    private struct structUser { static var loggedUser : PFUser? }

    func getUser(userName : String) ->  PFUser {
        var error : NSError?

        var qry = PFUser.query()
        qry.whereKey("username", equalTo:userName)

        var qryObjects = qry.findObjects(&error)

        return qryObjects[0] as PFUser
    }


    func getFriends(userName : String) -> NSArray? {
        var friends = NSMutableArray()
        var error : NSError?
        var qry = PFQuery(className: "User")
        qry.whereKey("username", equalTo:userName)

        qry.orderByAscending("username")

        var qryObjects = qry.findObjects(&error)

        if error != nil {
            if qryObjects != nil {

            }
        }
        return friends
    }

    func getAllUsersButUser(userName : String) -> NSArray? {
        var friends = NSMutableArray()
        var error : NSError?

        var qry = PFUser.query()
        qry.whereKey("username", notEqualTo:userName)


        qry.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for r in results {
                    friends.addObject(r)
                }
            }
            else {
                println("error:\(error)")
            }
        }
        return friends
    }

    func signupUser(user:String, password: String) {
        var newUser = PFUser()
        newUser.username = user
        newUser.password = password

        newUser.signUpInBackgroundWithBlock({ (res : Bool, error : NSError!) -> Void in
            if error != nil {
                println("error:\(error)")
            }
        });
    }


    func addFollower(user : PFUser, follower : PFUser) {
        var followers = user.relationForKey("followers")

        followers.addObject(follower)
        user.save()
    }

    internal class var loggedUser: PFUser {
        get { return structUser.loggedUser! }
        set { structUser.loggedUser = newValue }
    }
    
    
    
}