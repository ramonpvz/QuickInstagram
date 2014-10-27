//
//  ViewController.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()<FBLoginViewDelegate>
    @property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FBLoginView class];
    return YES;
}

- (IBAction)login:(UIButton *)sender {
}

- (IBAction)signup:(UIButton *)sender {
}
@end
