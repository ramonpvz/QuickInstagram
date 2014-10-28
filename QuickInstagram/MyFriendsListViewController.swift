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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - delegate table methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.makeFriendInstance(DatabaseManager.loggedUser).friends!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        var currentFriend = DatabaseManager.makeFriendInstance(DatabaseManager.loggedUser).friends?[indexPath.row] as User

        cell.textLabel.text = currentFriend.userName

        return cell
    }
}