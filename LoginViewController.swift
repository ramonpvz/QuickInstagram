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
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        handleLogginScreen()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        handleLogginScreen()
    }

    func showError(error : String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func handleLogginScreen() {
        DatabaseManager.loggedUser = PFUser.currentUser()
        if FBSession.activeSession().isOpen {//logged with FB
            showFBUserLogged()
        }
        else if PFUser.currentUser() != nil {
            showUserLogged()
        }
        else {//not logged
            showLoggedOut()
        }



    }

    func showUserLogged() {
        println("showUserLogged")
        password.hidden = true
        user.hidden = true
        notRegisteredLabel.hidden = true
        signupButton.hidden = true
        orLabel.hidden = true
        fbLoginButton.hidden = true
        logginButton.hidden = false
        fbStatusLabel.hidden = false
        fbNameLabel.hidden = false
        fbProfilePicture.hidden = false;

        logginButton.setTitle("out", forState: UIControlState.Normal)
        fbStatusLabel.text = "Logged as"
        fbNameLabel.text = DatabaseManager.toUser(DatabaseManager.loggedUser!).userName

    }

    func showFBUserLogged() {
        println("showFBUserLogged")
        password.hidden = true
        user.hidden = true
        notRegisteredLabel.hidden = true
        signupButton.hidden = true
        orLabel.hidden = true
        logginButton.hidden = true

        fbStatusLabel.hidden = false
        fbNameLabel.hidden = false
        fbProfilePicture.hidden = false;
        fbLoginButton.hidden = false
    }

    func showLoggedOut() {
        println("showLoggedOut")
        password.hidden = false
        user.hidden = false
        notRegisteredLabel.hidden = false
        signupButton.hidden = false
        orLabel.hidden = false
        fbLoginButton.hidden = false
        logginButton.hidden = false
        fbStatusLabel.hidden = true
        fbNameLabel.hidden = true
        fbProfilePicture.hidden = true;

        logginButton.setTitle("login", forState: UIControlState.Normal)
    }

    //MARK - Facebook Delegates

    // This method will be called when the user information has been fetched
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        fbProfilePicture.profileID = user.objectID
        fbNameLabel.text = user.name
        if DatabaseManager.getUser(user.name) != nil {
            DatabaseManager.loggedUser = DatabaseManager.login(user.name, password: user.objectID)
        }
        else {//not registered, signing up
            DatabaseManager.signupUser(user.name, password: user.objectID)
            DatabaseManager.loggedUser = DatabaseManager.login(user.name, password: user.objectID)
        }

    }
    // Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        fbStatusLabel.text = "Logged in as"
        showFBUserLogged()
    }

    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        fbProfilePicture.profileID = nil
        fbNameLabel.text = ""
        fbStatusLabel.text = "User not logged"


        showLoggedOut()//TODO - falta revisar como interceptar la confirmacion de logout
        //        if PFUser.currentUser() == nil {
        //            handleLogginScreen()
        //        }
    }

    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("mamo:\(error)")
    }

    func application(application : UIApplication, url : NSURL, sourceApplication : String, annotation : AnyObject) -> Bool {
        // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }

    //MARK - View Actions

    @IBAction func login(sender: UIButton) {
        if logginButton.titleLabel?.text == "out" {
            DatabaseManager.loggedUser = nil
            PFUser.logOut()
        }
        else {
            var error : NSError?
            if user.text == "" || password.text == ""{
                showError("All fields are required")
            }
            else {
                //setting singleton instance og logged in user
                DatabaseManager.loggedUser = DatabaseManager.login(user.text, password: password.text)
                if DatabaseManager.loggedUser != nil {
                    //changing to my friends tab
                    logginButton.setTitle("out", forState: UIControlState.Normal)
                    tabBarController?.selectedIndex = 1
                }
                else {
                    println("Error on login:\(error)")
                    showError("Invalid login credentials")
                }
            }
        }
        handleLogginScreen()
    }
}


