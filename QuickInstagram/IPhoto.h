//
//  Photo.h
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ITopic.h"
#import "IUser.h"

@interface IPhoto : PFObject <PFSubclassing>

@property PFFile *image;
@property ITopic *topic;
@property IUser *user;
@property NSString *caption;

@end