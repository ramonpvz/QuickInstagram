//
//  Comment.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "IComment.h"

@implementation IComment

@dynamic description;

@dynamic photo;

+ (void) load
{
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"IComment";
}

@end
