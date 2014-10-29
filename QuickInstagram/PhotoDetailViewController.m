//
//  PhotoDetailViewController.m
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "ILike.h"

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
    
    ILike *like = [ILike object];
    IUser *user = [IUser object];
    user.name = @"Mary";
    user.gender = @"Female";
    user.quote = @"Anything...";
    like.user = user;
    like.photo = self.photo;

    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Like saved...");
        [self displayLikes];
    }];

}

//Close the view controller
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
