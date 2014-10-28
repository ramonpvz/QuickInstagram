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

    var myFriends = NSMutableArray()
    var currenUser : PFUser?
    let db = DatabaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        println("estatico user:\(DatabaseManager.loggedUser)")

        
    }

    //MARK - delegate table methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell

        //cell.textLabel.text = "algo"

        return cell
    }
}