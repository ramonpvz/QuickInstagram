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
    @IBOutlet var notRegisteredLabel: UILabel!
    @IBOutlet var logginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var orLabel: UILabel!

    @IBOutlet var fbLoginButton: FBLoginView!
    @IBOutlet var fbProfilePicture: FBProfilePictureView!
    @IBOutlet var fbStatusLabel: UILabel!
    @IBOutlet var fbNameLabel: UILabel!

    //MARK - helper functions
    override func viewDidLoad() {
        super.viewDidLoad()

        hideFacebookLogin(true)
        hideOwnLoggin(false)

        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if PFUser.currentUser() != nil {
            println("Found logged user")
            DatabaseManager.loggedUser = PFUser.currentUser()
            tabBarController?.selectedIndex = 1
        }
        else {
            tabBarController?.selectedIndex = 0
        }
    }

    func showError(error : String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //MARK - Facebook Delegates

    // This method will be called when the user information has been fetched
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        fbProfilePicture.profileID = user.objectID
        fbNameLabel.text = user.name
    }
    // Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        hideFacebookLogin(false)
        hideOwnLoggin(true)
        fbStatusLabel.text = "U r logged in as"
    }

    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        fbProfilePicture.profileID = nil
        fbNameLabel.text = ""
        fbStatusLabel.text = "U r not logged"
        hideFacebookLogin(true)
        hideOwnLoggin(false)
    }

    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("mamo:\(error)")
    }
    //MARK - View Actions

    @IBAction func login(sender: UIButton) {
        var error : NSError?
        //setting singleton instance og logged in user
        DatabaseManager.loggedUser = PFUser.logInWithUsername(user.text, password: password.text, error: &error)
        if DatabaseManager.loggedUser != nil {
            //changing to my friends tab
            tabBarController?.selectedIndex = 1
        }
        else {
            println("Error on login:\(error)")
            showError("Invalid login credentials")
        }
    }

    func application(application : UIApplication, url : NSURL, sourceApplication : String, annotation : AnyObject) -> Bool {
        // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }


    func hideOwnLoggin(val : Bool) {
        password.hidden = val
        user.hidden = val
        notRegisteredLabel.hidden = val
        logginButton.hidden = val
        signupButton.hidden = val
        orLabel.hidden = val
    }

    func hideFacebookLogin(val : Bool) {
        fbProfilePicture.hidden = val
        fbStatusLabel.hidden = val
        fbNameLabel.hidden = val
    }


}


