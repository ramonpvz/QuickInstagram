//
//  PhotoDetailViewController.h
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPhoto.h"

@interface PhotoDetailViewController : UIViewController

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSString *imageName;
@property IPhoto *photo;

- (IBAction)close:(id)sender;

@end
