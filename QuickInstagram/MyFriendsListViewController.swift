//
//  MyFriendsListViewController.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation
import UIKit

class MyFriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, dbProtocol {
    //MARK - view properties
    @IBOutlet var myFriendsTableView: UITableView!
    //MARK - classs properties
    var myFriends : NSArray?


    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil {
            myFriends = []
            tabBarController?.selectedIndex = 0
        }
        else {
            DatabaseManager.delegate = self
            myFriends = DatabaseManager.toUser(DatabaseManager.loggedUser!).friends
        }
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            myFriends = []
            tabBarController?.selectedIndex = 0
        }
        else {
            DatabaseManager.delegate = self
            myFriends = DatabaseManager.toUser(DatabaseManager.loggedUser!).friends
        }
    }
    //MARK - delegate DB methods
    func loadDataFinished() {
        myFriendsTableView.reloadData()
    }

    //MARK - delegate table methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        var currentFriend = myFriends![indexPath.row] as User

        cell.textLabel.text = currentFriend.userName

        return cell
    }

    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        DatabaseManager.loggedUser = PFUser.currentUser()
        tabBarController?.selectedIndex = 0
    }
    
}