//
//  Photo.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "IPhoto.h"

@implementation IPhoto

@dynamic image;
@dynamic topic;
@dynamic user;
@dynamic caption;

+ (void) load {
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"IPhoto";
}

@end