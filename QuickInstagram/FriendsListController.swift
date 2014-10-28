//
//  FriendsListController.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation
import UIKit

class FriendsListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var people : NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        people = DatabaseManager.getAllUsersButUser(DatabaseManager.toUser(DatabaseManager.loggedUser).userName)
    }





    //MARK - delegate table methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var person = people![indexPath.row] as User

        cell.textLabel.text = person.userName

        return cell
    }

    //MARK - helper methods
    func showError(error : String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
