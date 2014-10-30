//
//  CommentTableViewController.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/29/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *comments;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comments = [NSMutableArray array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end