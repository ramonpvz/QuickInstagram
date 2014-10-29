//
//  Like.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "ILike.h"

@implementation ILike

@dynamic user;

@dynamic photo;

+ (void) load
{
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"ILike";
}

@end