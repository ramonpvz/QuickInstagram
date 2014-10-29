//
//  User.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "IUser.h"

@implementation IUser

@dynamic name;
@dynamic gender;
@dynamic age;
@dynamic quote;

+ (void) load
{
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"IUser";
}

@end
