//
//  PhotoViewController.m
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoDetailViewController.h"

@interface PhotoViewController ()

@property IBOutlet UIScrollView *photoScrollView;
@property NSMutableArray *allImages;

@property MBProgressHUD *HUD;
@property MBProgressHUD *refreshHUD;

#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 4
#define THUMBNAIL_COLS 4
#define THUMBNAIL_WIDTH 75
#define THUMBNAIL_HEIGHT 75

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
