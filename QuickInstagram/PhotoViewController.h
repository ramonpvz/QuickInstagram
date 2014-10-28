//
//  PhotoViewController.h
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#include <stdlib.h> // For math functions including arc4random (a number randomizer)

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate>

- (IBAction)refresh:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;

@end
