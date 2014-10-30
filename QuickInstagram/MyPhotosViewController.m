//
//  MyPhotosViewController.m
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "MyPhotosViewController.h"
#import "QuickInstagram-Swift.h"
#import "CollectionImageViewCell.h"
#import "IPhoto.h"
#import "PhotoDetailViewController.h"

@interface MyPhotosViewController ()

@property MBProgressHUD *refreshHUD;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *allImages;

@end

@implementation MyPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"user=%@", DatabaseManager.loggedUser);
    self.allImages = [NSMutableArray array];
    [self loadImages];
}

- (void)loadImages{
    self.refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.refreshHUD];

    // Register for HUD callbacks so we can remove it from the window at the right time
    self.refreshHUD.delegate = self;

    // Show the HUD while the provided method executes in a new thread
    [self.refreshHUD show:YES];

    PFQuery *queryForPhoto = [IPhoto query];
    PFUser *user = DatabaseManager.loggedUser;
    [queryForPhoto whereKey:@"user" equalTo:user];
    [queryForPhoto orderByAscending:@"createdAt"];

    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (self.refreshHUD) {
                [self.refreshHUD hide:YES];

                self.refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:self.refreshHUD];

                self.refreshHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

                // Set custom view mode
                self.refreshHUD.mode = MBProgressHUDModeCustomView;

                self.refreshHUD.delegate = self;
            }
            NSLog(@"Successfully retrieved %lu photos.", objects.count);

            self.allImages = [NSMutableArray arrayWithArray:objects];
            [self.collectionView reloadData];
            
        } else {
            [self.refreshHUD hide:YES];
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self.refreshHUD hide:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    IPhoto *photo = [self.allImages objectAtIndex:indexPath.row];

    cell.imageView.image = [UIImage imageWithData:[[NSData alloc] initWithData:photo.image.getData]];

    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)collectionImageView {
    if ([segue.identifier isEqualToString:@"imgageDetailSegue"])
    {
        PhotoDetailViewController *targetVC = segue.destinationViewController;
        NSIndexPath *iPath = [self.collectionView indexPathForCell:collectionImageView];
        IPhoto *photo = [self.allImages objectAtIndex:iPath.row];
        targetVC.photo = photo;
        //targetVC.selectedImage = [UIImage imageWithData:[NSData dataWithData:photo.image.getData]];
    }
}


@end
