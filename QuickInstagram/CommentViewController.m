//
//  CommentTableViewController.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/29/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "CommentViewController.h"
#import "IComment.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource , UINavigationControllerDelegate>
@property NSMutableArray *comments;
@property (strong, nonatomic) IBOutlet UITextField *commentTxt;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comments = [NSMutableArray array];
    [self displayComments];
}

- (IBAction)saveComment:(id)sender {
    IComment *comment = [IComment object];
    comment.photo = self.photo;
    comment.description = self.commentTxt.text;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.commentTxt.text = @"";
        [self displayComments];
    }];
}

- (void) displayComments {
    PFQuery *queryForComments = [IComment query];
    [queryForComments whereKey:@"photo" equalTo:self.photo];
    [queryForComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.comments = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self performSegueWithIdentifier:@"unwindComment" sender:self];
}

- (NSInteger) totalComments {
    return self.comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.comments objectAtIndex:indexPath.row][@"description"];
    return cell;
}

@end