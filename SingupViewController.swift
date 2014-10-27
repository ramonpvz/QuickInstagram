//
//  SingupViewController.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation
import UIKit

class SingupViewController: UIViewController {

    @IBOutlet var user: UITextField!
    @IBOutlet var password: UITextField!


    @IBAction func signup(sender: AnyObject) {
        if validateFields() {
            var newUser = PFUser()
            newUser.username = user.text
            newUser.password = password.text

            if newUser.signUp() {
                navigationController?.popToRootViewControllerAnimated(true)
            }
            else {
                user.text = ""
                password.text = ""
                showError("Signup error, try again please...")
            }
        }
    }

    func validateFields() -> Bool {
        if user.text == "" || password.text == "" {
            showError("All fields are required")
            return false
        }
        return true
    }

    func showError(error : String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }



}