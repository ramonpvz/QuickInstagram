//
//  PhotoDetailViewController.m
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "ILike.h"
#import "IComment.h"
#import "QuickInstagram-Swift.h"
#import "CommentViewController.h"

@interface PhotoDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *countLikes;
@property (strong, nonatomic) IBOutlet UILabel *countComments;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageWithData:[NSData dataWithData:self.photo.image.getData]];
    [self displayComments];
    [self displayLikes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)displayLikes {
    PFQuery *queryForLikes = [ILike query];
    [queryForLikes whereKey:@"photo" equalTo:self.photo];
    [queryForLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.countLikes.text = [NSString stringWithFormat:@"%li", objects.count];
    }];
}

- (void) displayComments {
    PFQuery *queryForComments = [IComment query];
    [queryForComments whereKey:@"photo" equalTo:self.photo];
    [queryForComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.countComments.text = [NSString stringWithFormat:@"%li", objects.count];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)collectionImageView {
    if ([segue.identifier isEqualToString:@"commentSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        CommentViewController *commentVC = [nc.viewControllers objectAtIndex:0];
        commentVC.photo = self.photo;
    }
}

// Bring the total of comments from source view controller
- (IBAction)unwindCommentViewController:(UIStoryboardSegue *)segue {
    CommentViewController *commentVC = segue.sourceViewController;
    self.countComments.text = [NSString stringWithFormat:@"%ld", (long)[commentVC totalComments]];
}

- (IBAction)like:(id)sender {
    PFUser *user = DatabaseManager.loggedUser;
    ILike *like = [ILike object];
    [like setObject:user forKey:@"user"];
    like.photo = self.photo;
    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self displayLikes];
    }];
}

//Close the view controller
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
