//
//  FriendsListController.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation
import UIKit

class FriendsListController: UIViewController, UITableViewDataSource, UITableViewDelegate, dbProtocol {
    //MARK - classs properties
    var myFriends : NSArray?
    var people : NSArray?
    var friends : NSArray?

    //MARK - view properties
    @IBOutlet var friendsTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.delegate = self
        people = DatabaseManager.getAllUsersButUser(DatabaseManager.toUser(DatabaseManager.loggedUser!).userName)
        friends = DatabaseManager.toUser(DatabaseManager.loggedUser!).friends
    }

    //MARK - delegate DB methods
    func loadDataFinished() {
        people = DatabaseManager.getAllUsersButUser(DatabaseManager.toUser(DatabaseManager.loggedUser!).userName)
        friends = DatabaseManager.toUser(DatabaseManager.loggedUser!).friends
        friendsTableView.reloadData()
    }

    //MARK - delegate table methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell

        var person = people![indexPath.row] as User

        cell.accessoryType = UITableViewCellAccessoryType.None

        if isAFriend(person.userName) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        cell.textLabel.text = person.userName

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell!.accessoryType == UITableViewCellAccessoryType.None {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            DatabaseManager.addRelatedPearsonAs(people?.objectAtIndex(indexPath.row) as User, asType: DatabaseManager.personType.FRIEND)
        }
        else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            DatabaseManager.deleteRelatedPearsonAs(people?.objectAtIndex(indexPath.row) as User, asType: DatabaseManager.personType.FRIEND)
        }
    }

    //MARK - helper methods
    func showError(error : String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func isAFriend(username : String) -> Bool {
        for f in friends! {
            if (f as User).userName == username {
                return true
            }
        }
        return false
    }
}
