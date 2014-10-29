//
//  Topic.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "ITopic.h"

@implementation ITopic

@dynamic hashtag;
@dynamic icon;

+ (void) load
{
    [self registerSubclass];
}

+ (NSString *) parseClassName
{
    return @"ITopic";
}

@end