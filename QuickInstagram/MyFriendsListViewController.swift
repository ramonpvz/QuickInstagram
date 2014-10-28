//
//  MyFriendsListViewController.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation
import UIKit

class MyFriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var myFriends : NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        myFriends = DatabaseManager.toUser(DatabaseManager.loggedUser).friends
    }

    //MARK - delegate table methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        var currentFriend = myFriends![indexPath.row] as User

        //cell.textLabel.text = currentFriend.userName

        return cell
    }
}