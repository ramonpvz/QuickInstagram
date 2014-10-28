//
//  User.swift
//  QuickInstagram
//
//  Created by eduardo milpas diaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

import Foundation

class User {

    var userName : String
    var userFacebook : String?
    var followers : NSArray?
    var friends : NSArray?



    init(userName : String) {
        self.userName = userName
    }
}



