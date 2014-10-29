//
//  Like.h
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "IPhoto.h"
#import "IUser.h"

@interface ILike : PFObject <PFSubclassing>

@property IUser *user;
@property IPhoto *photo;

@end