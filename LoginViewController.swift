//
//  LoginViewController.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {

    //MARK - View Properties


    @IBOutlet var password: UITextField!
    @IBOutlet var user: UITextField!
    @IBOutlet var fbLoginButton: FBLoginView!
    let db = DatabaseManager()
    var currenUser : PFUser?

    //MARK - helper functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func showError(error : String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //MARK - Facebook Delegates

    //MARK - View Actions

    
    @IBAction func login(sender: UIButton) {
        var error : NSError?
        currenUser = PFUser.logInWithUsername(user.text, password: password.text, error: &error)
        if currenUser != nil {
            //setting singleton instance og logged in user
            DatabaseManager.loggedUser = currenUser!
            //changing to my friends tab
            tabBarController?.selectedIndex = 1
        }
        else {
            println("Error on login:\(error)")
            showError("Invalid login credentials")
        }
    }
}


