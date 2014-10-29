//
//  WallViewController.m
//  QuickInstagram
//
//  Created by GLBMXM0002 on 10/28/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "TopicViewController.h"
#import "CollectionImageViewCell.h"
#import <Parse/Parse.h>
#import "IPhoto.h"
#import "ITopic.h"
#import "PhotoDetailViewController.h"

@interface TopicViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSMutableArray *topicImages;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topicImages = [NSMutableArray array];
    [self refreshDisplay];
}

- (void) refreshDisplay {

    PFQuery *queryForPhoto = [IPhoto query];
    [queryForPhoto  whereKey:@"topic" equalTo:self.topic];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.topicImages = [NSMutableArray arrayWithArray:objects];
        [self.collectionView reloadData];
    }];

}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)collectionImageView {
    if ([segue.identifier isEqualToString:@"imgDetailSegue"])
    {
        PhotoDetailViewController *targetVC = segue.destinationViewController;
        NSIndexPath *iPath = [self.collectionView indexPathForCell:collectionImageView];
        IPhoto *photo = [self.topicImages objectAtIndex:iPath.row];
        targetVC.photo = photo;
        //targetVC.selectedImage = [UIImage imageWithData:[NSData dataWithData:photo.image.getData]];
    }
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topicImages.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    IPhoto *photo = [self.topicImages objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:[[NSData alloc] initWithData:photo.image.getData]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
