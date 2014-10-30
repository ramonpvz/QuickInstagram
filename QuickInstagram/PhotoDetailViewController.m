//
//  PhotoDetailViewController.m
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "ILike.h"
#import "QuickInstagram-Swift.h"

@interface PhotoDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *countLikes;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageWithData:[NSData dataWithData:self.photo.image.getData]];
    [self displayLikes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)displayLikes {
    
    PFQuery *queryForLikes = [ILike query];
    [queryForLikes whereKey:@"photo" equalTo:self.photo];
    [queryForLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Total of likes: %lu", (unsigned long)objects.count);
        NSString *txt = [NSString stringWithFormat:@"%li", objects.count];
        self.countLikes.text = txt;
    }];

}

- (IBAction)like:(id)sender {

    PFUser *user = DatabaseManager.loggedUser;
    ILike *like = [ILike object];
    [like setObject:user forKey:@"user"];
    like.photo = self.photo;
    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Like saved...");
        [self displayLikes];
    }];

//    ILike *like = [ILike object];
//    User *user = DatabaseManager.loggedUser;
//    user.name = @"Mary";
//    like.user = user;
//    like.photo = self.photo;
//
//    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSLog(@"Like saved...");
//        [self displayLikes];
//    }];

}

//Close the view controller
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
