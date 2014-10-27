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

        var logedUser = PFUser.logInWithUsername(user.text, password: password.text, error: &error)
        if logedUser != nil {
            tabBarController?.selectedIndex = 1
        }
        else {
            println("Error on login:\(error)")
            showError("Invalid login credentials")
        }


        

    }


}


