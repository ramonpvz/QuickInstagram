//
//  CommentTableViewController.h
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/29/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPhoto.h"

@interface CommentViewController : UIViewController

@property IPhoto *photo;

- (NSInteger) totalComments;

@end