//
//  DatabaseManager.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation

@objc protocol dbProtocol {
    func loadDataFinished()
}

class DatabaseManager : NSObject{

    enum personType : String {
        case FRIEND = "friends"
        case FOLLOWER = "followers"
    }

    private struct structUser {
        static var loggedUser : PFUser?
        static var delegate : dbProtocol?
    }


    class func getUser(userName : String) ->  User? {
        var error : NSError?

        var qry = PFUser.query()
        qry.whereKey("username", equalTo:userName)

        var qryObjects = qry.findObjects(&error)

        if qryObjects.count > 0 {
            return toUser(qryObjects[0] as PFUser)
        }
        else {
            return nil
        }
    }

    class func getUserAsPFUser(userName : String) ->  PFUser {
        var error : NSError?

        var qry = PFUser.query()
        qry.whereKey("username", equalTo:userName)

        var qryObjects = qry.findObjects(&error)

        return qryObjects[0] as PFUser
    }

    class func toUser(pfUser : PFUser) -> User {
        //creating instance of friend
        var user = User(userName: pfUser.username)
        var friends = NSMutableArray()
        var followers = NSMutableArray()

        for f in getRelatedAs(pfUser, asType: personType.FRIEND)! {
            friends.addObject(User(userName: f.username))
        }
        for f in getRelatedAs(pfUser, asType: personType.FOLLOWER)! {
            followers.addObject(User(userName: f.username))
        }

        user.friends = NSArray(array: friends)
        user.followers = NSArray(array: followers)

        return user
    }


    class func getRelatedAs(user : PFUser, asType : personType) -> NSArray? {
        var relacion = user.relationForKey(asType.rawValue)
        var qry = relacion.query()

        return qry.findObjects()
    }

    class func getAllUsersButUser(userName : String) -> NSArray? {
        var friends = NSMutableArray()
        var error : NSError?

        var qry = PFUser.query()
        qry.whereKey("username", notEqualTo:userName)


        for r in qry.findObjects() {
            friends.addObject(self.toUser(r as PFUser))
        }


        //        qry.findObjectsInBackgroundWithBlock {
        //            (results: [AnyObject]!, error: NSError!) -> Void in
        //            if error == nil {
        //                for r in results {
        //                    friends.addObject(self.toUser(r as PFUser))
        //                }
        //            }
        //            else {
        //                println("error:\(error)")
        //            }
        //        }
        return friends
    }

    class func signupUser(user:String, password: String) {
        var newUser = PFUser()
        newUser.username = user
        newUser.password = password

        newUser.signUpInBackgroundWithBlock({ (res : Bool, error : NSError!) -> Void in
            if error != nil {
                println("error:\(error)")
            }
        });
    }

    class func addRelatedPearsonAs(person : User, asType : personType) {
        var relation = loggedUser?.relationForKey(asType.rawValue)

        relation?.addObject(getUserAsPFUser(person.userName))
        //loggedUser?.save()
        loggedUser?.saveInBackgroundWithBlock({ (succeeded : Bool, error : NSError!) -> Void in
            self.delegate!.loadDataFinished()
        })
    }

    class func deleteRelatedPearsonAs(person : User, asType : personType) {
        var relation = loggedUser?.relationForKey(asType.rawValue)

        relation?.removeObject(getUserAsPFUser(person.userName))
        loggedUser?.saveInBackgroundWithBlock({ (succeeded : Bool, error : NSError!) -> Void in
            self.delegate!.loadDataFinished()
        })
    }

    class func login(user : String, password : String) -> PFUser? {
        var error : NSError?
        return PFUser.logInWithUsername(user, password: password, error: &error)
    }

    internal class var loggedUser: PFUser? {
        get { return structUser.loggedUser }
        set { structUser.loggedUser = newValue }
    }
    
    internal class var delegate: dbProtocol? {
        get { return structUser.delegate }
        set { structUser.delegate = newValue }
    }
    
    
    
}